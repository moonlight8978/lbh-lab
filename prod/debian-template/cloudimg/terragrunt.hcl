include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-iso"
}

inputs = {
  url = "https://cdimage.debian.org/images/cloud/bookworm/20250909-2230/debian-12-nocloud-amd64-20250909-2230.qcow2"
  node_name = "pve1"
  datastore_id = "local"
  file_name = "debian-12-nocloud-amd64.qcow2.iso"
  location = "/var/lib/vz/template/iso"
}
