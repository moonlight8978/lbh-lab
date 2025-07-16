include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../terraform/modules/proxmox-vm"
}

inputs = include.root.locals.values
