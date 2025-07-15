include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../../modules/proxmox-vm"
}

include "env" {
  path = "${get_terragrunt_dir()}/env.hcl"
  expose = true
}

dependency "disk" {
  config_path = "../disk"
}

inputs = merge(include.env.locals, {
  cdrom_file_id = dependency.disk.outputs.file_id
})
