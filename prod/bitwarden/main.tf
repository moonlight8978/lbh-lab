variable "bitwarden_project_id" {
  type = string
}

data "bitwarden_project" "main" {
  id = var.bitwarden_project_id
}

variable "secrets" {
  type = map(object({
    data = map(string)
  }))
}

locals {
  secrets = flatten([for app, secret in var.secrets : [for key, value in secret.data : { key = "${app}/${key}", value = value }]])
}

resource "bitwarden_secret" "main" {
  for_each = { for secret in local.secrets : secret.key => secret.value }

  project_id = data.bitwarden_project.main.id
  key        = each.key
  value      = each.value
  note       = "Managed by Terraform"
}
