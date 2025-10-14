include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "."
}

inputs = merge(include.root.locals.values, {
  zone_name = "bichls.dev"
})
