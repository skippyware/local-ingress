#!/usr/bin/env sh

set -e

export HOST_GATEWAY="$(getent hosts _gw | awk '{ print $1 }')"

# export the docker host gateway address
echo "${HOST_GATEWAY}" > docker.gateway

# macos export
DARWIN_PATH=darwin
DARWIN_ALIAS_PLIST_NAME=org.user.lo0-docker-gateway-alias
DARWIN_ALIAS_FILENAME="${DARWIN_ALIAS_PLIST_NAME}.plist"

mkdir -p "${DARWIN_PATH}"

# export the plist definition for persistent loopback alias
cat > "${DARWIN_PATH}/${DARWIN_ALIAS_FILENAME}" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${DARWIN_ALIAS_PLIST_NAME}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>ProgramArguments</key>
    <array>
      <string>/sbin/ifconfig</string>
      <string>lo0</string>
      <string>alias</string>
      <string>${HOST_GATEWAY}</string>
    </array>
</dict>
</plist>
EOF

