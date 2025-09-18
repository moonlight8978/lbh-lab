variable "vm" {
  type = object({
    vm_id = number
  })
}

variable "cloudimg" {
  type = object({
    location = string
    file_name = string
  })
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

variable "compression" {
  type = string
  default = "none"
}

variable "datastore_id" {
  type = string
}

resource "random_string" "temp_file" {
  length  = 16
  special = false
}

locals {
  decompress = {
    "xz" = <<EOF
cp ${var.cloudimg.location} /tmp/${trimsuffix(var.cloudimg.file_name, ".iso")}
xz -d /tmp/${trimsuffix(var.cloudimg.file_name, ".iso")}
mv /tmp/${trimsuffix(var.cloudimg.file_name, ".xz.iso")} /tmp/${random_string.temp_file.result}
EOF
    "none" = <<EOF
cp ${var.cloudimg.location} /tmp/${random_string.temp_file.result}
EOF
  }
}

resource "null_resource" "diskimport" {
  triggers = {
    manual = "1"
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
      "qm set ${var.vm.vm_id} --delete scsi0",
      "qm unlink ${var.vm.vm_id} --idlist unused0",

      # Decompress image
      local.decompress[var.compression],

      # Import cloudimg disk, replace the current one
      "qm importdisk ${var.vm.vm_id} /tmp/${random_string.temp_file.result} ${var.datastore_id}",
      "qm set ${var.vm.vm_id} --scsihw virtio-scsi-single --scsi0 ${var.datastore_id}:vm-${var.vm.vm_id}-disk-0",
    ])
  }
}
