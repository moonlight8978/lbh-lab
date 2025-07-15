#cloud-config
hostname: ${name}
timezone: Asia/Bangkok
package_update: true
package_upgrade: true
users:
  - name: labo
    groups:
      - sudo
    ssh_authorized_keys:
      %{ for key in ssh_keys ~}
      - ${key}
      %{ endfor ~}
    sudo: ALL=(ALL) NOPASSWD:ALL
