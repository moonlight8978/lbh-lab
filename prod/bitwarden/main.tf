variable "bitwarden_project_id" {
  type = string
}

data "bitwarden_project" "main" {
  id = var.bitwarden_project_id
}

variable "secrets" {
  type = map(object({
    data     = optional(map(string))
    children = optional(map(map(string)))
  }))
}

locals {
  secrets   = flatten([for app, secret in var.secrets : [for key, value in secret.data : { key = "${app}/${key}", value = value }] if secret.data != null])
  childrens = flatten([for app, secret in var.secrets : [for child, value in secret.children : { key = "${app}/${child}", value = value }] if secret.children != null])
}

resource "bitwarden_secret" "main" {
  for_each = { for secret in local.secrets : secret.key => secret.value }

  project_id = data.bitwarden_project.main.id
  key        = each.key
  value      = each.value
  note       = "Managed by Terraform"
}

resource "bitwarden_secret" "children" {
  for_each = { for secret in local.childrens : secret.key => secret.value }

  project_id = data.bitwarden_project.main.id
  key        = each.key
  value      = jsonencode(each.value)
  note       = "Managed by Terraform"
}
