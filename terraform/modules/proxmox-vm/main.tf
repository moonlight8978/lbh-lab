locals {
  # default to 1:2 ratio
  memory = var.memory == -1 ? var.cpu * 1024 * 2 : var.memory * 1024
}

resource "proxmox_virtual_environment_vm" "main" {
  name      = var.name
  node_name = var.node_name
  vm_id     = var.vm_id

  dynamic "clone" {
    for_each = var.clone_vm_id != null ? [var.clone_vm_id] : []

    content {
      vm_id = var.clone_vm_id
    }
  }

  cpu {
    cores = var.cpu
    limit = var.cpu
    type  = "x86-64-v3"
    numa  = false
  }

  memory {
    dedicated = local.memory
  }

  agent {
    enabled = var.agent
  }

  network_device {
    bridge = "vmbr0"
  }

  boot_order    = ["scsi0"]
  scsi_hardware = "virtio-scsi-single"

  dynamic "disk" {
    for_each = var.disks

    content {
      interface    = "scsi${disk.key}"
      iothread     = disk.value.iothread
      datastore_id = disk.value.datastore_id
      size         = disk.value.size
      file_format  = "raw"
      path_in_datastore = disk.value.path_in_datastore
    }
  }

  dynamic "initialization" {
    for_each = var.cloudinit ? [true] : []

    content {
      interface            = "ide2"
      network_data_file_id = proxmox_virtual_environment_file.network_data_cloud_config.id
      user_data_file_id    = proxmox_virtual_environment_file.user_data_cloud_config.id
      meta_data_file_id    = proxmox_virtual_environment_file.meta_data_cloud_config.id
    }
  }

  started = var.started
  on_boot = var.on_boot

  tags = var.tags

  lifecycle {
    ignore_changes = [network_device, started, boot_order]
  }
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.main.vm_id
}

output "ip4" {
  value = var.ip4
}
