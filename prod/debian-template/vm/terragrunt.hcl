include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "vm" {
  path   = find_in_parent_folders("vm.hcl")
  expose = true
}

terraform {
  source = "../../../terraform/modules/proxmox-vm"
}

dependency "disk" {
  config_path = "../disk"
}

inputs = merge(include.root.locals.values, include.vm.locals, {
  vm_id         = include.root.locals.values.debian_template_vm_id
  cdrom_file_id = dependency.disk.outputs.file_id
})
