#cloud-config
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: no
      addresses:
        - ${ip4}
      routes:
        - to: default
          via: ${gateway4}
      nameservers:
        search: [icetea.local]
        addresses: [10.241.90.21]
