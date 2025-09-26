locals {
  talos_template_id = 10010
  ubuntu_template_id = 10020

  controller1 = {
    clone_vm_id = local.ubuntu_template_id

    name = "control-1"
    vm_id = 10101
    cpu = 2
    memory = 6
    ip4 = "10.242.20.161/24"
    gateway4 = "10.242.20.140"
    disks = [{
      size = 30
      datastore_id = "local-lvm"
    }]
  }

  controller2 = {
    clone_vm_id = local.ubuntu_template_id

    name = "control-2"
    vm_id = 10102
    cpu = 2
    memory = 6
    ip4 = "10.242.20.162/24"
    gateway4 = "10.242.20.140"
    disks = [{
      size = 30
      datastore_id = "local-lvm"
    }]
  }

  worker1 = {
    clone_vm_id = local.ubuntu_template_id

    name = "worker-1"
    vm_id = 10121
    cpu = 4
    memory = 8
    ip4 = "10.242.20.171/24"
    gateway4 = "10.242.20.140"
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
      },
      {
        datastore_id = "/dev/disk/by-path/pci-0000",
        path_in_datastore = "00:14.0-usb-0:4:1.0-scsi-0:0:0:0",
        iothread = null,
        size = 465
      }
    ]
  }

  worker2 = {
    clone_vm_id = local.ubuntu_template_id

    name = "worker-2"
    vm_id = 10122
    cpu = 4
    memory = 8
    ip4 = "10.242.20.172/24"
    gateway4 = "10.242.20.140"
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
    clone_vm_id = local.ubuntu_template_id

    name = "worker-3"
    vm_id = 10123
    cpu = 4
    memory = 8
    ip4 = "10.242.20.174/24"
    gateway4 = "10.242.20.140"
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

  warp_connector = {
    clone_vm_id = local.ubuntu_template_id

    name = "warp-connector"
    vm_id = 10202
    cpu = 1
    memory = 1
    disks = [{
      datastore_id = "local-lvm",
      size = 10
    }]
    ip4 = "10.242.20.142/24"
    gateway4 = "10.242.20.1"
  }

  playground = {
    clone_vm_id = local.ubuntu_template_id

    name = "playground"
    vm_id = 10210
    cpu = 1
    memory = 1
    disks = [{
      datastore_id = "local-lvm",
      size = 10
    }]
    ip4 = "10.242.20.145/24"
    gateway4 = "10.242.20.1"
  }
}
