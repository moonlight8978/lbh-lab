locals {
  talos_template_id = 10010

  controller1 = {
    name = "control-1"
    vm_id = 10101
    cpu = 4
    memory = 8
    ip4 = "10.242.20.161/24"
    gateway4 = "10.242.20.1"
    disks = [{
      size = 30
      datastore_id = "local-lvm"
    }]
  }

  controller2 = {
    name = "control-2"
    vm_id = 10102
    cpu = 4
    memory = 8
    ip4 = "10.242.20.162/24"
    gateway4 = "10.242.20.1"
    disks = [{
      size = 30
      datastore_id = "local-lvm"
    }]
  }

  worker1 = {
    name = "worker-1"
    vm_id = 10121
    cpu = 4
    memory = 8
    ip4 = "10.242.20.171/24"
    gateway4 = "10.242.20.1"
    disks = [
      {
        size = 50
        datastore_id = "local-lvm"
      },
      {
        size = 50,
        datastore_id = "local-lvm"
      },
      {
        size = 100,
        datastore_id = "slow"
      }
    ]
  }

  worker2 = {
    name = "worker-2"
    vm_id = 10122
    cpu = 4
    memory = 8
    ip4 = "10.242.20.172/24"
    gateway4 = "10.242.20.1"
    disks = [
      {
        size = 50
        datastore_id = "local-lvm"
      },
      {
        size = 50,
        datastore_id = "local-lvm"
      },
      {
        size = 100,
        datastore_id = "slow"
      }
    ]
  }

  worker3 = {
    name = "worker-3"
    vm_id = 10123
    cpu = 4
    memory = 8
    ip4 = "10.242.20.174/24"
    gateway4 = "10.242.20.1"
    disks = [
      {
        size = 50
        datastore_id = "local-lvm"
      },
      {
        size = 50,
        datastore_id = "local-lvm"
      },
      {
        size = 100,
        datastore_id = "slow"
      }
    ]
  }
}
