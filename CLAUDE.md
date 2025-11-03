# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

LBH Lab (Le Bich Home Lab) is a comprehensive home infrastructure project running on Proxmox with Kubernetes workloads. This is a single-machine setup (i7-10700, 32GB RAM) with plans to migrate to a 3-node Pi cluster.

## Core Technologies

- **Virtualization**: Proxmox VE for VM management
- **Container Orchestration**: k0s Kubernetes distribution (not Talos despite having config files)
- **Infrastructure as Code**: Terraform with Terragrunt for multi-environment management
- **Configuration Management**: Ansible for server setup and configuration
- **Secrets Management**: SOPS with Age encryption for all sensitive data
- **Task Runner**: Taskfile (Go-based) for local automation
- **GitOps**: ArgoCD for Kubernetes application deployment

## Common Development Commands

### Infrastructure Provisioning
```bash
# Provision template machines
task tf:unit -- prod/ubuntu-template apply

# Provision network VMs (VPN, proxies)
task vm

# Bootstrap entire cluster (k8s nodes + cluster + apps)
task bootstrap

# Provision individual components
task tf:unit -- prod/kubernetes apply
```

### Terraform Operations
```bash
# Run on individual units (all environments in directory)
task tf:unit -- ./path/to/stack <apply|plan|output|init>

# Run on entire stack
task tf:stack -- ./path/to/stack <apply|plan|output|init>
```

### Kubernetes Operations
```bash
# Bootstrap k0s cluster
task k0s:bootstrap

# Bootstrap Kubernetes applications
task k8s:bootstrap

# Set node roles for storage and workers
task k8s:noderole

# Login to ArgoCD (Machine)
task argocd:login
task argocd:bootstrap

# Or login to ArgoCD with SSO (GUI login)
task argocd:login:sso
```

### Ansible Operations
```bash
# Install Ansible collections
task ansible:init

# Run playbooks
task ansible:run -- playbook-name.yml

# Setup network VMs
ansible-playbook -i inventory.yml ansible/playbooks/setup-network.yml
```

### Secrets Management
```bash
# Decrypt secrets for editing
task sops:dec

# Encrypt secrets after editing
task sops:enc

# Update specific secret providers (e.g., Bitwarden)
task secret:update
```

### Schema Management
```bash
# Sync Kubernetes schemas from cluster
task schema

# Alternative command
task kss
```

## Architecture Overview

### Directory Structure
- `prod/`: Terragrunt units for infrastructure provisioning (VMs, templates, services)
- `kubernetes/`: Kubernetes configurations and applications
  - `k0s/`: k0s cluster configuration (`k0sctl.yml`)
  - `talos/`: Talos OS configs (legacy, not actively used)
  - `charts/`: Helm charts for applications managed via ArgoCD
- `ansible/`: Playbooks and roles for server configuration
- `terraform/`: Terraform modules and shared configurations
- `scripts/`: Utility scripts

### Infrastructure Layers
1. **Physical Layer**: Single Proxmox host
2. **Virtualization**: VMs for network services and Kubernetes nodes
3. **Container Orchestration**: k0s cluster with 1 controller + 2 workers
4. **Application Layer**: Applications deployed via Helm charts and ArgoCD

### Key Components
- **Network VMs**: VPN (WireGuard), proxy services (Xray), Cloudflare tunnel connector
- **Kubernetes Cluster**: k0s v1.34.1 with Cilium CNI, OpenEBS storage
- **Applications**: Self-hosted services (Jellyfin, Gitea, AdGuard, Grafana, etc.)
- **Monitoring**: Prometheus stack with Grafana
- **Security**: Cloudflare tunnels for external access, internal VPN

## Development Workflow

### Making Infrastructure Changes
1. Modify Terragrunt configurations in `prod/`
2. Test with `task tf:unit -- prod/path plan`
3. Apply with `task tf:unit -- prod/path apply`
4. For sensitive changes, update secrets with `task sops:dec` → edit → `task sops:enc`

### Adding Applications
1. Add Helm chart to `kubernetes/charts/`
2. Configure via ArgoCD applications in `kubernetes/charts/argocd-apps/`
3. Sync with `task k8s:bootstrap` or `argocd app sync <app-name>`

### Managing Secrets
- All secrets are in `secrets.yml` (encrypted with SOPS)
- Use `task sops:dec` to decrypt, edit, then `task sops:enc` to encrypt
- Never commit unencrypted secrets

## Code Style and Standards

Following the DevOps guidelines from `.cursor/rules/devops.mdc`:
- Use dash-case for file names and directory structures
- Use alphanumeric names for Kubernetes manifest files (no separators)
- Apply Infrastructure-as-Code principles
- Use modular, reusable configurations
- Follow GitOps principles for Kubernetes management
- Implement least privilege access controls

## Pre-commit Hooks

The repository uses pre-commit hooks for:
- Terraform formatting (`terraform fmt`)
- YAML formatting (excluding certain directories)
- Trailing whitespace cleanup
- Secret scanning with GitGuardian

## Important Notes

- This is a home lab environment focused on automation and reproducibility
- Network uses DHCP from ISP router - networking kept simple
- Storage includes flexible USB drives for cross-platform compatibility
- Backup/restore systems implemented
- Cost-optimized for electricity efficiency
- Currently in development with focus on automated provisioning
