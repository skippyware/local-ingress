#!/usr/bin/env sh

set -e

if [[ -d /docker-entrypoint-init.d ]]; then
  run-parts /docker-entrypoint-init.d
fi

sed -e "s/\${ACME_DNS_ZONE}/${ACME_DNS_ZONE:-local}/g" /data/config.cfg > /etc/acme-dns/config.cfg

exec "$@"
