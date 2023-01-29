#!/usr/bin/env bash

trap 'rm -f "$TMP_VAULT_PASS"' EXIT

TMP_VAULT_PASS="$(mktemp)"            || exit 1

"$(dirname "$0")"/get-vault-pass.sh 2>/dev/null > "$TMP_VAULT_PASS"

ansible-playbook \
  --vault-password-file "$TMP_VAULT_PASS" \
  -e @"$(dirname "$0")/../../private/deploy/ansible/host_vars/trex/openvpn.yml" \
  playbooks/setup-router.yml \
  "$@"
