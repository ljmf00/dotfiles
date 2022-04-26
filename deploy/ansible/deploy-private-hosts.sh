#!/usr/bin/env bash

trap 'rm -f "$TMP_VAULT_PASS" "$TMP_PRIVATE_HOSTS"' EXIT

TMP_VAULT_PASS="$(mktemp)"    || exit 1
TMP_PRIVATE_HOSTS="$(mktemp)" || (rm "$TMP_VAULT_PASS" && exit 1)

chmod 600 "$TMP_VAULT_PASS" "$TMP_PRIVATE_HOSTS"

gpg --batch --decrypt --quiet "$(dirname "$0")/private-hosts.pgp" 2>/dev/null > "$TMP_PRIVATE_HOSTS"
"$(dirname "$0")"/get-vault-pass.sh 2>/dev/null > "$TMP_VAULT_PASS"

ansible-playbook playbooks/setup-private.yml \
  --private-key="$TMP_VAULT_PASS" \
  --inventory-file="$TMP_PRIVATE_HOSTS" \
  "$@"
