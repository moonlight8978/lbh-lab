# LBH Lab Infrastructure

## The system includes

- Proxmox for VM provisioning

- DNS

- Kubernetes for workloads: internal services, hosting, ...

## Goals

- Automated provisioning
  - [x] Proxmox machines post installation
  - [x] K3s cluster

  - The following must be done manually:
    - [ ] Proxmox installation on bare metals
    - [ ] Template machine installation

- Security
  - [ ] Egress Management
  - [ ] Access Control: OPA, Kyverno
  - [ ] Internal Network Encryption in transit (TLS)

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
