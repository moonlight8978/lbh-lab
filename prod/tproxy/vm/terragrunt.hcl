include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-vm"
}

inputs = merge(include.root.locals.values, {
  name = "tproxy"
  vm_id = 10200
  cpu = 2
  memory = 2
  disks = [{
    datastore_id = "local-lvm",
    size = 20
  }]
  clone_vm_id = include.root.locals.values.ubuntu_template_id
  ip4 = "10.242.20.140/24"
  gateway4 = "10.242.20.1"
})
