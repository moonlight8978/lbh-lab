include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../modules/proxmox-vm"
}

include "vm" {
  path   = find_in_parent_folders("vm.hcl")
  expose = true
}

dependency "disk" {
  config_path = "../disk"
}

inputs = merge(include.vm.locals, {
  cdrom_file_id = dependency.disk.outputs.file_id
})
