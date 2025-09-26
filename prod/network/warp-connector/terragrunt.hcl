include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-vm"
}

inputs = merge(include.root.locals.values, include.root.locals.values.warp_connector)
