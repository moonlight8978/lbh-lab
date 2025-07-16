locals {
  workspace = "prod/kubernetes/control2/vm"

  clone_vm_id = 1000
  vm_id = 8002
  name = "k8s-control2"
  node_name = "pve1"
  tags = ["debian", "k8s", "controller"]

  cpu = 2

  on_boot = true

  ip4 = "10.242.20.143/24"
  gateway4 = "10.242.20.1"

  cloudinit = true

  disk = {
    size = 20
    datastore_id = "local-lvm"
  }
}
