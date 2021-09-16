# Ansible deployment

This folder provides a collection of ansible roles and playbooks to
automatically setup machines.

## Pre requirements

Before run an ansible playbook or any role individually, please install the
required dependencies:

```bash
ansible-galaxy collection install -r requirements.yml
```

## Available configurations

You can setup all machines at once using:

```bash
ansible-playbook playbooks/setup.yml
```

To deploy a specific tag, please do:

```bash
ansible-playbook playbooks/setup.yml -t sudo
```

For example, the above command will only deploy `sudo`-based configurations.

### Deploy locally

If you prefer to deploy some tag locally, please run with the following
arguments:

```bash
ansible-playbook playbooks/setup.yml --inventory-file local_hosts -t base
```

## Machines topology

### `tornado`

Disk:
```
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 464.7G  0 disk
└─sda1   8:1    0 464.7G  0 part /mnt
sdb      8:16   0 930.4G  0 disk
└─sdb1   8:17   0 930.4G  0 part /var
sdc      8:32   0 110.8G  0 disk
├─sdc1   8:33   0   954M  0 part /boot/efi
└─sdc2   8:34   0 109.9G  0 part /
```

Network:
```
nm-bond0 <-- eno0 && eno1
```
