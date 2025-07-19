resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name
  source_raw {
    data = templatefile("${path.module}/cloudinit/user_data.tftpl", {
      name     = var.name
      ssh_keys = var.ssh_keys
    })
    file_name = "${var.name}-user-data-cloud-config.yml"
  }
}

resource "proxmox_virtual_environment_file" "network_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name
  source_raw {
    data = templatefile("${path.module}/cloudinit/network_data.tftpl", {
      ip4      = var.ip4
      gateway4 = var.gateway4
    })
    file_name = "${var.name}-network-data-cloud-config.yml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name
  source_raw {
    data = templatefile("${path.module}/cloudinit/meta_data.tftpl", {
      name  = var.name
      vm_id = var.vm_id
    })
    file_name = "${var.name}-meta-data-cloud-config.yml"
  }
}
