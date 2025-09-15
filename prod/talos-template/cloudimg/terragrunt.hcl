include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-iso"
}

inputs = {
  # nocloud
  # amd64
  # pkgs:
  # - nvme-cli
  # - qemu-guest-agent
  url = "https://factory.talos.dev/image/4dbfff09111d77e81e05a35969a4bea8eed7658afd27a35d779d770f6863bb14/v1.11.1/nocloud-amd64.raw.xz"
  node_name = "pve1"
  datastore_id = "local"
  file_name = "talos-amd64.raw.xz.iso"
  location = "/var/lib/vz/template/iso"
}
