locals {
  vm_id = 1000
  cpu = 2
  name = "debian-template"
  node_name = "pve1"
  on_boot = false

  tags = ["template", "debian"]

  disk = {
    size = 5
    datastore_id = "local-lvm"
  }
}
