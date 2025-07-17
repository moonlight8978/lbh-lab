include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "."
}

dependency "control1" {
  config_path = "../control1/vm"
}

dependency "control2" {
  config_path = "../control2/vm"
}

dependency "control3" {
  config_path = "../control3/vm"
}

inputs = merge(include.root.locals.values, {
  controllers = [
    dependency.control1.outputs.ip4,
    dependency.control2.outputs.ip4,
    dependency.control3.outputs.ip4,
  ]

  root_dir = get_repo_root()
})
