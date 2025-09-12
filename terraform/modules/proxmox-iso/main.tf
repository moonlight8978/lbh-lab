variable "url" {
  type = string
}

variable "datastore_id" {
  type = string
}

variable "node_name" {
  type = string
}

variable "file_name" {
  type = string
  default = null
}

variable "location" {
  type = string
}

resource "proxmox_virtual_environment_download_file" "main" {
  content_type = "iso"
  url = var.url
  file_name = var.file_name
  datastore_id = var.datastore_id
  node_name      = var.node_name
  upload_timeout = 900
}

output "location" {
  value = "${var.location}/${var.file_name}"
}
