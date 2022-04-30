#!/bin/sh
exec gpg --batch --decrypt --quiet "$(dirname "$0")/../../private/deploy/terraform/tfvars/default.tfvars.pgp"
