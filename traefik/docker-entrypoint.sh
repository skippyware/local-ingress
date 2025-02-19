#!/usr/bin/env sh

set -e

export CORE_DNS_ADDRESS="$(getent hosts coredns | awk '{ print $1 }')"

if [[ -d /docker-entrypoint-init.d ]]; then
  run-parts /docker-entrypoint-init.d
fi

set -- "$@" "--certificatesresolvers.default.acme.dnschallenge.resolvers=${CORE_DNS_ADDRESS}:53"

exec "$@"
