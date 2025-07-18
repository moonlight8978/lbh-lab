locals {
  workspace = "prod/kubernetes/worker3/vm"

  clone_vm_id = 1000
  vm_id       = 8103
  name        = "k8s-worker3"
  node_name   = "pve1"
  tags        = ["debian", "k8s", "worker"]

  cpu    = 4
  memory = 10

  on_boot = true

  ip4      = "10.242.20.147/24"
  gateway4 = "10.242.20.1"

  cloudinit = true

  disk = {
    size         = 50
    datastore_id = "local-lvm"
  }

  additional_disks = [
    {
      datastore_id = "slow-lvm"
      size         = 100
    },
    {
      datastore_id = "local-lvm"
      size         = 30
    }
  ]
}
