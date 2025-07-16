variable "controllers" {
  type = list(string)

}

variable "root_dir" {
  type = string
}

variable "k3s_server_token" {
  type = string
}

locals {
  install = var.controllers[0]
  joins = slice(var.controllers, 1, length(var.controllers))
}

resource "local_file" "k3sup_install_config" {
  content = templatefile("${path.module}/templates/k3sup.tftpl", {
    install = true
    ip4 = local.install
    name = "control-1"
    join_url = "https://${local.install}:6443"
    k3s_server_token = var.k3s_server_token
    join_ip4 = local.install
  })

  filename = "${var.root_dir}/tmp/k3sup-1.yml"
}

resource "local_file" "k3sup_join_config" {
  for_each = toset(local.joins)

  content = templatefile("${path.module}/templates/k3sup.tftpl", {
    install = false
    ip4 = each.value
    name = "control-${index(var.controllers, each.value) + 1}"
    join_url = "https://${local.install}:6443"
    k3s_server_token = var.k3s_server_token
    join_ip4 = local.install
  })

  filename = "${var.root_dir}/tmp/k3sup-${index(var.controllers, each.value) + 1}.yml"
}
