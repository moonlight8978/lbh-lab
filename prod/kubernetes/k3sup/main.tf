variable "controllers" {
  type = list(string)
}

variable "workers" {
  type = list(string)
}

variable "root_dir" {
  type = string
}

variable "k3s_server_token" {
  type = string
}

variable "kube_vip_ip4" {
  type = string
}

variable "kube_cluster_cidr" {
  type = string
}

variable "kube_service_cidr" {
  type = string
}

variable "k3s_version" {
  type = string
}

variable "kube_bootstrap" {
  type = bool
}

locals {
  install = var.controllers[0]
  joins   = slice(var.controllers, 1, length(var.controllers))
  tls_san = concat(var.controllers, [var.kube_vip_ip4])
}

resource "local_file" "install_config" {
  content = templatefile("${path.module}/templates/server.tftpl", {
    install           = true
    ip4               = local.install
    name              = "control-${index(var.controllers, local.install) + 1}"
    k3s_server_token  = var.k3s_server_token
    join_ip4          = local.install
    kube_cluster_cidr = var.kube_cluster_cidr
    kube_service_cidr = var.kube_service_cidr
    tls_san           = local.tls_san
    k3s_version       = var.k3s_version
  })

  filename = "${var.root_dir}/tmp/server-${index(var.controllers, local.install) + 1}.yml"
}

resource "null_resource" "install" {
  count = var.kube_bootstrap ? 1 : 0

  provisioner "local-exec" {
    command     = "c7r k3sup --config tmp/server-${index(var.controllers, local.install) + 1}.yml"
    working_dir = var.root_dir
  }
}

resource "local_file" "join_config" {
  for_each = toset(local.joins)

  content = templatefile("${path.module}/templates/server.tftpl", {
    install           = false
    ip4               = each.value
    name              = "control-${index(var.controllers, each.value) + 1}"
    k3s_server_token  = var.k3s_server_token
    join_ip4          = local.install
    tls_san           = local.tls_san
    kube_cluster_cidr = var.kube_cluster_cidr
    kube_service_cidr = var.kube_service_cidr
    k3s_version       = var.k3s_version
  })

  filename = "${var.root_dir}/tmp/server-${index(var.controllers, each.value) + 1}.yml"
}

resource "null_resource" "join" {
  for_each = var.kube_bootstrap ? toset(local.joins) : []

  depends_on = [null_resource.install]

  provisioner "local-exec" {
    command     = "c7r k3sup --config tmp/server-${index(var.controllers, each.value) + 1}.yml"
    working_dir = var.root_dir
  }
}

resource "local_file" "worker_config" {
  for_each = toset(var.workers)

  filename = "${var.root_dir}/tmp/agent-${index(var.workers, each.value) + 1}.yml"
  content = templatefile("${path.module}/templates/agent.tftpl", {
    ip4               = each.value
    join_ip4          = local.install
    name              = "worker-${index(var.workers, each.value) + 1}"
    k3s_version = var.k3s_version
  })
}

resource "null_resource" "agent" {
  for_each = var.kube_bootstrap ? toset(var.workers) : []

  depends_on = [null_resource.join]

  provisioner "local-exec" {
    command     = "c7r k3sup --config tmp/agent-${index(var.workers, each.value) + 1}.yml"
    working_dir = var.root_dir
  }
}
