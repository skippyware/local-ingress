#!/usr/bin/env sh

set -e

SRC_DIR=${1:-./system-config/darwin}

install -g wheel -o root -m 0644 \
    ${SRC_DIR}/org.user.lo0-docker-gateway-alias.plist \
    /Library/LaunchDaemons/org.user.lo0-docker-gateway-alias.plist

launchctl load /Library/LaunchDaemons/org.user.lo0-docker-gateway-alias.plist
