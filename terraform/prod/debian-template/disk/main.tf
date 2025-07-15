resource "proxmox_virtual_environment_download_file" "debian_bookworm" {
  content_type       = "iso"
  datastore_id       = "local"
  file_name          = "debian-12.11.0-amd64-netinst.iso"
  node_name          = "pve1"
  url                = "https://chuangtzu.ftp.acc.umu.se/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
}

output "file_id" {
  value = proxmox_virtual_environment_download_file.debian_bookworm.id
}
