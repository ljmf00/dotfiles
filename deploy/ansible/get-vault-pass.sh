#!/bin/sh
exec gpg --batch --decrypt --quiet "$(dirname "$0")/../../private/deploy/ansible/vault-password.gpg"
