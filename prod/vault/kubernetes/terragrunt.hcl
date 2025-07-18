include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "."
}

dependency "secrets" {
  config_path = "../secrets"
}

inputs = merge(include.root.locals.values,
  {
    secret_path = dependency.secrets.outputs.path
  }
)
