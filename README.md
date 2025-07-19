# LBH Lab (Le Bich Home Lab) Infrastructure

## Status

- The project is currently in-development

- Focus on automated provisioning, operating the home system

- Hardware: It's running on a single gaming desktop machine (i7-10700 CPU, 32GB RAM, 512GB SSD, 1TB HDD)

  I'm planning to migrate to 3 machines pi (or mini pc) cluster once my finances are in better shape. Why pi? Because of those electricity bills hit hard!

- Networking: DHCP from a single ISP router. My networking knowledge is pretty basic, so I'll keep things as simple as possible

## The system includes

- Proxmox for VM provisioning

- Kubernetes for workloads: internal services, hosting, ...

- Terraform (Terragrunt) to provision almost everything automatically

- Just, Taskfile for local task runner, and Ansible for remote task runner

## Manual operations

- Proxmox installation on bare metals

- Template machine installation

  -> Use qm CLI to import the cloud image?

## Goals

- Automated provisioning
  - [x] Proxmox machines post installation
  - [x] K3s cluster

- Security
  - [ ] Egress Management
  - [ ] Access Control: OPA, Kyverno
  - [ ] Internal Network Encryption in transit (TLS)

- Services
  - [ ] DNS for local network
  - [ ] VPN

## How to provision the cluster

- Install Proxmox, setup disks, ...

- Setup the PVE node
```bash
ansible-playbook -i inventory.ini pve/playbooks/pve.yml
```

- Provision the template
```bash
just terragrunt apply prod/debian-template --all --non-interactive
```

- Setup the template machine

- Provision the k8s cluster

```bash
task k8s:provision
```

- Installs the boostrapping apps

```bash
task k8s:boostrap-apps
```

## Development

### Terraform

- Terragrunt
- Terraform
- SOPS (w/ Age)

- To run terragrunt commands

```bash
just terragrunt <cmd> <dir> <-flags>

just terragrunt apply prod/debian-template --all
just terragrunt init prod/debian-template --all
```

## Credits

The project is heavily inspired of those awesome projects

- https://github.com/bjw-s-labs/home-ops

- https://github.com/M0NsTeRRR/homelabv3-infra
