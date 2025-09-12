include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "cloudimg" {
  config_path = "../cloudimg"
}

dependency "vm" {
  config_path = "../vm"
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-diskimport"
}

inputs = merge(include.root.locals.values, {
  location = dependency.cloudimg.outputs.location
  vm_id = dependency.vm.outputs.vm_id
  proxmox_node_ip = include.root.locals.values.proxmox_node1_ip
})
