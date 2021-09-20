#!/usr/bin/env bash

set -eo pipefail

SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do
  DOTFILES_FOLDER="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DOTFILES_FOLDER/$SOURCE"
done
DOTFILES_FOLDER="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
DOTFILES_FOLDER="$(dirname "$DOTFILES_FOLDER")"
unset SOURCE

# shellcheck source=utils-job-pool.sh
source "$DOTFILES_FOLDER/scripts/utils-job-pool.sh"

GPGKEY_FINGERPRINT="0xE2AB2BF8F3ECABE2E149F2FDBC4308319CE40B64"

GPGKEYSERVERS=(
  agora.cenditel.gob.ve
  fks.pgpkeys.eu
  gozer.rediris.es
  keys.openpgp.org
  keyserver-01.2ndquadrant.com
  keyserver-02.2ndquadrant.com
  keyserver-03.2ndquadrant.com
  keyserver.dobrev.eu
  keyserver.escomposlinux.org
  keyserver.snt.utwente.nl
  keyserver.ubuntu.com
  keyserver1.computer42.org
  keyserver2.computer42.org
  keywin.trifence.ch
  pgp.benny-baumann.de
  pgp.circl.lu
  pgp.cyberbits.eu
  pgp.key-server.io
  pgp.mit.edu
  pgp.surf.nl
  pgpkeys.eu
  sks.hnet.se
  sks.pgpkeys.eu
  sks.pod01.fleetstreetops.com
  sks.pod02.fleetstreetops.com
  sks.pyro.eu.org
  sks.srv.dumain.com
  sks.stsisp.ro
  vm-keyserver.spline.inf.fu-berlin.de
  zimmermann.mayfirst.org
  zuul.rediris.es
)

gpg_call() {
  # for key in $(gpg --list-keys --with-colons | awk -F: '/^pub:/ { print $5 }'); do
    gpg --keyserver "$2" "--$1-key" "$GPGKEY_FINGERPRINT"
  # done
}

job_pool_init 30 0

set +e +o pipefail

# TODO: fix and use job pool
for keyserver in "${GPGKEYSERVERS[@]}"; do
  gpg_call recv "$keyserver"
done

for keyserver in "${GPGKEYSERVERS[@]}"; do
  gpg_call send "$keyserver"
done

job_pool_wait
job_pool_shutdown
