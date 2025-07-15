variable "name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "node_name" {
  type    = string
  default = "pve1"
}

variable "clone_vm_id" {
  type = number
  default = null
  nullable = true
}

variable "disk" {
  type = object({
    datastore_id = string
    size = number
  })
}

variable "additional_disks" {
  type = list(object({
    datastore_id = string
    size = number
  }))
  default = []
}

variable "cpu" {
  type = number
}

variable "memory" {
  type    = number
  default = -1
}

variable "cdrom_file_id" {
  type = string
  default = null

  nullable = true
}

variable "tags" {
  type = list(string)
  default = []
}

variable "on_boot" {
  type = bool
  default = true
}

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

  boot_order    = ["scsi0"]
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
      interface = "scsi${index(var.additional_disks, disk) + 1}"
      iothread = true
      datastore_id = disk.value.datastore_id
      size = disk.value.size
      file_format = "raw"
    }
  }

  dynamic "cdrom" {
    for_each = var.cdrom_file_id != null ? [var.cdrom_file_id] : []

    content {
      enabled = true
      file_id = var.cdrom_file_id
      interface = "ide2"
    }
  }

  started = true
  on_boot = var.on_boot

  tags = var.tags

  lifecycle {
    ignore_changes = ["network_device", "started"]
  }
}
