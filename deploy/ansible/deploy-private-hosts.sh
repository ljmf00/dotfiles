#!/usr/bin/env bash

trap 'rm -f "$TMP_VAULT_PASS" "$(dirname "$0")/private_hosts"' EXIT

TMP_VAULT_PASS="$(mktemp)"            || exit 1
touch "$(dirname "$0")/private_hosts" || (rm "$TMP_VAULT_PASS" && exit 1)

chmod 600 "$TMP_VAULT_PASS" "$(dirname "$0")/private_hosts"

gpg --batch --decrypt --quiet "$(dirname "$0")/private-hosts.pgp" 2>/dev/null > "$(dirname "$0")/private_hosts"
"$(dirname "$0")"/get-vault-pass.sh 2>/dev/null > "$TMP_VAULT_PASS"

ansible-playbook \
  --vault-password-file "$TMP_VAULT_PASS" \
  --inventory "$(dirname "$0")/private_hosts" \
  playbooks/setup-private.yml \
  "$@"
