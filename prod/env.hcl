locals {
  debian_template_vm_id = 1000
  kube_vip_ip4 = "192.168.0.40"
  kube_cluster_cidr = "10.42.0.0/16"
  kube_service_cidr = "10.43.0.0/16"
  k3s_version  = "v1.33.1+k3s1"
  # Set this to true to bootstrap the cluster
  kube_bootstrap = false
}
