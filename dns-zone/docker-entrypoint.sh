#!/usr/bin/env sh

set -e

export HOST_GATEWAY="$(getent hosts _gw | awk '{ print $1 }')"
export ACME_DNS_ADDRESS="$(getent hosts acme-dns | awk '{ print $1 }')"

if [[ -d /docker-entrypoint-init.d ]]; then
  run-parts /docker-entrypoint-init.d
fi

mkdir -p /data/zones/resolvers
echo "nameserver ${ACME_DNS_ADDRESS}" > /data/zones/resolvers/acme-dns.conf

exec "$@"
