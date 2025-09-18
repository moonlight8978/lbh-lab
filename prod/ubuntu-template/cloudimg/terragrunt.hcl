include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-iso"
}

inputs = {
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  node_name = "pve1"
  datastore_id = "local"
  file_name = "ubuntu-noble-server-cloudimg-amd64.img"
  location = "/var/lib/vz/template/iso"
}
