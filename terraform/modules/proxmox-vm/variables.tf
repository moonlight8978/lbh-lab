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
  type     = number
  default  = null
  nullable = true
}

variable "disks" {
  type = list(object({
    datastore_id = string
    size         = number
  }))
}

variable "cpu" {
  type = number
}

variable "memory" {
  type    = number
  default = -1
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "on_boot" {
  type    = bool
  default = true
}

variable "cloudinit" {
  type    = bool
  default = true
}

variable "ssh_keys" {
  type    = list(string)
  default = []
}

variable "ip4" {
  type = string
}

variable "gateway4" {
  type = string
}

variable "agent" {
  type    = bool
  default = true
}

variable "started" {
  type    = bool
  default = true
}

variable "vm_passwd" {
  type = string
}
