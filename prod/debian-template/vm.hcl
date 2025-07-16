locals {
  name = "debian-template"
  node_name = "pve1"
  tags = ["template", "debian"]

  cpu = 1
  memory = 1024

  on_boot = false

  ip4 = "10.242.20.138/24"
  gateway4 = "10.242.20.1"

  cloudinit = false

  boot_disk = "ide0"
  disk = {
    size = 5
    datastore_id = "local-lvm"
  }
}
