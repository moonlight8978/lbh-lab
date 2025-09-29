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

- Taskfile for local task runner, and Ansible for automating Linux server setup

## Manual operations

- Proxmox installation on bare metals

- ~~Template machine installation~~

  ~~-> Use qm CLI to import the cloud image?~~

  Already use cloud image, and cloudinit to bootstrap the VM

## Goals

- Automated provisioning
  - [x] template machines
  - [x] network (vpn, proxy) nodes
  - [x] k0s nodes
  - [x] k0s cluster

- Security
  - [x] Cloudflare tunnel between datacenters
  - [x] User-to-site VPN
  - [ ] Egress Management
  - [ ] Access Control: OPA, Kyverno
  - [ ] Internal Network Encryption in transit (TLS)

- Miscs
  - [x] The whole infrastructure must be reproducible
  - [x] Flexible HDD storage (macOS, Windows friendly, easy to copy data for non-tech family members)
  - [x] Backup/Restore
  - [x] Cost (Electricity bills) optimized
  - [ ] Monitoring with near real-time alerts
  - [ ] DNS for local network
  - [ ] Geoblock, CVE protection for external access

## How to provision the cluster

- Install Proxmox, setup disks, ...

- Setup the PVE node
```bash
ansible-playbook -i inventory.ini pve/playbooks/pve.yml
```

- Provision the template
```bash
task tf:unit -- prod/ubuntu-template apply
```

- Provision the networking VMs

```bash
task vm
```

- Provision the k8s nodes, cluster

```bash
task bootstrap
```

## Development

### Terraform

- Terragrunt
- Terraform
- SOPS (w/ Age)

- To run terragrunt commands

```bash
task tf:unit -- ./relative-path/to/stack <apply|output|plan|init>
task tf:stack -- ./relative-path/to/stack <apply|output|plan|init>
```

### Ansible

```bash
task ansible:init
task ansible:run -- playbook-name.yml --tags <tag>
```

### Sops

```bash
task sops:enc
task sops:dec
task secret:update
```

### Json schema sync

- Use [kubernetes-schema-store](https://github.com/moonlight8978/kubernetes-schema-store)

```bash
task kss
```

## Credits

The project is heavily inspired of those awesome projects

- https://github.com/onedr0p/home-ops

- https://github.com/bjw-s-labs/home-ops

- https://github.com/M0NsTeRRR/homelabv3-infra
