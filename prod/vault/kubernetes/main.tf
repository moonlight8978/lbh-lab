variable "secrets" {
  type = list(object({
    name                             = string
    bound_service_account_namespaces = list(string)
    data                             = map(string)
  }))
}

variable "secret_path" {
  type = map(string)
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "example" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://10.43.0.1:443"
}

output "mount" {
  value = vault_auth_backend.kubernetes.path
}

resource "vault_policy" "main" {
  for_each = { for secret in var.secrets : secret.name => secret }

  name   = each.key
  policy = <<EOT
path "${var.secret_path[each.key]}" {
  capabilities = ["read"]
}
EOT
}

resource "vault_kubernetes_auth_backend_role" "main" {
  for_each = { for secret in var.secrets : secret.name => secret }

  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = each.key
  bound_service_account_names      = ["${each.key}-vault"]
  bound_service_account_namespaces = each.value.bound_service_account_namespaces
  token_ttl                        = 3600
  token_policies                   = [vault_policy.main[each.key].name]
}
