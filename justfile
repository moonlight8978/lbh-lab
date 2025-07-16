terragrunt command dir *FLAGS:
  #! /bin/sh
  set -eu

  secrets=$(pwd)/secrets.yml
  cd {{dir}}
  terragrunt {{command}} --auth-provider-cmd "sops decrypt $secrets --output-type json" {{FLAGS}}


