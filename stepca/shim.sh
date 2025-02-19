#!/usr/bin/env bash

set -e

COREDNS_ADDRESS="$(getent hosts coredns | awk '{ print $1 }')"

step ca provisioner update acme --x509-default-dur 2160h

exec /usr/local/bin/step-ca --resolver=${COREDNS_ADDRESS}:53 --password-file $PWDPATH $CONFIGPATH
