include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-iso"
}

inputs = {
  url = "https://factory.talos.dev/image/376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba/v1.11.1/nocloud-amd64.raw.xz"
  node_name = "pve1"
  datastore_id = "local"
  file_name = "talos-amd64.raw.xz.iso"
  location = "/var/lib/vz/template/iso"
}
