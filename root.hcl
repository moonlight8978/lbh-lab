locals {
  secret_vars = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yml")))
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))
  local_env_vars    = try(read_terragrunt_config("${get_terragrunt_dir()}/env.hcl"), { locals : {} })
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  values = merge(local.secret_vars, local.global_vars.locals, local.local_env_vars.locals, local.env_vars.locals)
}

remote_state {
  backend = "s3"
  config = {
    endpoint                           = "https://${local.values.cloudflare_account_id}.r2.cloudflarestorage.com"
    bucket                             = "terraform"
    key                                = "lbhlab/${local.values.workspace}/terraform.tfstate"
    region                             = "apac"
    skip_credentials_validation        = true
    skip_metadata_api_check            = true
    skip_region_validation             = true
    disable_aws_client_checksums       = true
    disable_bucket_update              = true
    skip_bucket_root_access            = true
    skip_bucket_public_access_blocking = true
    skip_bucket_enforced_tls           = true
    skip_bucket_ssencryption           = true
    skip_bucket_versioning             = true
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

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
