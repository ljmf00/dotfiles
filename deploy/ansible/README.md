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
