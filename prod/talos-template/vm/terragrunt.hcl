include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/terraform/modules/proxmox-vm"
}

inputs = merge(include.root.locals.values, {
  name = "talos-template"
  vm_id = 10010
  cpu = 1
  memory = 1
  disks = [{
    datastore_id = "local-lvm",
    size = 3
  }]

  cloudinit = false
  on_boot = false
  started = false

  ip4      = "10.242.20.138/24"
  gateway4 = "10.242.20.1"

})
