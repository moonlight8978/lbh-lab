locals {
  workspace = "prod/dns/vm"

  clone_vm_id = 1000
  vm_id = 100
  name = "dns"
  node_name = "pve1"
  tags = ["core", "debian"]

  cpu = 1
  memory = 1024

  on_boot = true

  ip4 = "10.242.20.139/24"
  gateway4 = "10.242.20.1"

  cloudinit = true

  disk = {
    size = 5
    datastore_id = "local-lvm"
  }
}
