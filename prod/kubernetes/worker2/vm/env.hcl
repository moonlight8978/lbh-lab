locals {
  workspace = "prod/kubernetes/worker2/vm"

  clone_vm_id = 1000
  vm_id       = 8102
  name        = "k8s-worker2"
  node_name   = "pve1"
  tags        = ["debian", "k8s", "worker"]

  cpu = 6
  memory = 12288

  on_boot = true

  ip4      = "10.242.20.146/24"
  gateway4 = "10.242.20.1"

  cloudinit = true

  disk = {
    size         = 50
    datastore_id = "local-lvm"
  }

  additional_disks = [
    {
      datastore_id = "slow-lvm"
      size = 100
    },
    {
      datastore_id = "local-lvm"
      size = 30
    }
  ]
}
