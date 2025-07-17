locals {
  # default to 1:2 ratio
  memory = var.memory == -1 ? var.cpu * 1024 * 2 : var.memory
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
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  boot_order    = [var.boot_disk]
  scsi_hardware = "virtio-scsi-single"

  disk {
    interface = "scsi0"
    iothread = true
    datastore_id = var.disk.datastore_id
    size = var.disk.size
    file_format = "raw"
  }

  dynamic "disk" {
    for_each = var.additional_disks

    content {
      interface = "scsi${disk.key + 1}"
      iothread = true
      datastore_id = disk.value.datastore_id
      size = disk.value.size
      file_format = "raw"
    }
  }

  dynamic "cdrom" {
    for_each = var.cdrom_file_id != null ? [var.cdrom_file_id] : []

    content {
      file_id = var.cdrom_file_id
      interface = "ide0"
    }
  }

  dynamic "initialization" {
    for_each = var.cloudinit ? [true] : []

    content {
      interface = "ide2"
      network_data_file_id = proxmox_virtual_environment_file.network_data_cloud_config.id
      user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
      meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config.id
    }
  }

  started = true
  on_boot = var.on_boot

  tags = var.tags

  lifecycle {
    ignore_changes = [network_device, started, boot_order]
  }
}

output "ip4" {
  value = try([for ip in flatten(proxmox_virtual_environment_vm.main.ipv4_addresses): ip if ip != "127.0.0.1"][0], null)
}
