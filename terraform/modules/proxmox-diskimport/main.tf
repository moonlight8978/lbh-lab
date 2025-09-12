variable "vm_id" {
  type = number
}

variable "proxmox_node_ip" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
}

variable "file_name" {
  type = string
}

variable "compression" {
  type = "string"
  default = "none"
}

variable "datastore_id" {
  type = string
}

locals {
  decompress = {
    "xz" = ""
  }
}

resource "null_resource" "diskimport" {
  triggers = {
    vm_id = var.vm_id
  }

  connection {
    type     = "ssh"
    user     = split("@", var.proxmox_username)[0]
    password = var.proxmox_password
    host     = var.proxmox_node_ip
  }

  provisioner "remote-exec" {
    inline = compact([
      # Delete existing disk
      "qm set ${var.vm_id} --delete scsi0",
      "qm unlink ${var.vm_id} --idlist unused0",

      var.compression == "none" ? null "",

      # Import cloudimg disk, replace the current one
      "qm importdisk ${var.vm_id} /var/lib/vz/template/iso/${var.file_name} ${var.datastore_id}",
      "qm set ${var.vm_id} --scsihw virtio-scsi-single --scsi0 ${var.datastore_id}:vm-${var.vm_id}-disk-0",
      "qm start ${var.vm_id}",
    ])
  }
}
