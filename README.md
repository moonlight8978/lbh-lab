# LBH Lab (Le Bich Home Lab) Infrastructure

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
