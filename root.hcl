locals {
  secret_vars = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yml")))
  global_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env_vars    = read_terragrunt_config("${get_terragrunt_dir()}/env.hcl")

  values = merge(local.secret_vars, local.global_vars.locals, local.env_vars.locals)
}

inputs = merge(local.secret_vars, local.global_vars, local.env_vars)

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.78.1"
    }
  }
}

provider "proxmox" {
  endpoint = "${local.values.proxmox_endpoint}"
  insecure = true
  username = "${local.values.proxmox_username}"
  password = "${local.values.proxmox_password}"
}
EOF
}
