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

variable "boot_disk" {
  type = string
  default = "scsi0"
}

variable "cloudinit" {
  type = bool
  default = true
}

variable "ssh_keys" {
  type = list(string)
  default = []
}

variable "ip4" {
  type = string
}

variable "gateway4" {
  type = string
}
