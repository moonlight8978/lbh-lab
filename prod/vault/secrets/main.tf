variable "secrets" {
  type = list(object({
    name = string
    data = map(string)
  }))
}

resource "vault_mount" "kvv2" {
  path        = "secret"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

output "mount" {
  value = vault_mount.kvv2.path
}

resource "vault_kv_secret_backend_v2" "main" {
  mount        = vault_mount.kvv2.path
  max_versions = 5
}

resource "vault_kv_secret_v2" "main" {
  for_each = { for secret in var.secrets : secret.name => secret }

  mount     = vault_mount.kvv2.path
  name      = "prod/${each.key}"
  data_json = jsonencode(each.value.data)
}

output "path" {
  value = { for secret in var.secrets : secret.name => vault_kv_secret_v2.main[secret.name].path }
}
