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

dependency "worker1" {
  config_path = "../worker1/vm"
}

dependency "worker2" {
  config_path = "../worker2/vm"
}

dependency "worker3" {
  config_path = "../worker3/vm"
}

inputs = merge(include.root.locals.values, {
  controllers = [
    dependency.control1.outputs.ip4,
    dependency.control2.outputs.ip4,
    dependency.control3.outputs.ip4,
  ]

  workers = [
    dependency.worker1.outputs.ip4,
    dependency.worker2.outputs.ip4,
    dependency.worker3.outputs.ip4,
  ]

  root_dir = get_repo_root()
})
