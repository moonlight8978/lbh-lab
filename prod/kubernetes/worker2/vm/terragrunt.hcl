include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-vm"
}

inputs = merge(include.root.locals.values, include.root.locals.values.worker2, {
  clone_vm_id = include.root.locals.values.talos_template_id
})
