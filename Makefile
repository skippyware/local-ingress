ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PLATFORM := unsupported
ifeq ($(OS),Windows_NT)
    PLATFORM := windows
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        PLATFORM := linux
    endif
    ifeq ($(UNAME_S),Darwin)
        PLATFORM := darwin
    endif
endif

build:
	docker compose build dns-zone traefik

ca-extract: start
	rm -f ./system-config/ca.crt
	docker compose cp --follow-link stepca:/home/step/certs/root_ca.crt ./system-config/ca.crt

ca-install-unsupported:
	@echo Failed to detect platform or platform unsupported
	@echo Install the Root CA manually
	exit 1

ca-install-darwin: ca-extract
	security add-trusted-cert -d -r trustRoot -k "${HOME}/Library/Keychains/login.keychain-db" -p ssl ca.crt

ca-install: ca-extract ca-install-$(PLATFORM)

system-config-generate:
	docker compose run --rm --entrypoint='' --no-deps -v "${PWD}/system-config:/system-config" -v "${PWD}/dns-zone/system-config.sh:/system-config.sh" -w /system-config dns-zone /system-config.sh

system-config-unsupported: system-config-generate
	@echo Failed to detect platform or platform unsupported
	@echo Create IP aliases manually
	@echo -n 'Docker subnet: '
	@cat ./system-config/docker.gateway
	exit 1

system-config-darwin: system-config-generate
	cp $(ROOT_DIR)/system-config/darwin/org.user.lo0-docker-gateway-alias.plist ${TMPDIR}/
	cp $(ROOT_DIR)/system-config/tools/system-config-darwin.sh ${TMPDIR}/
	osascript -e "do shell script \"${TMPDIR}/system-config-darwin.sh ${TMPDIR}\" with administrator privileges"
	rm ${TMPDIR}/org.user.lo0-docker-gateway-alias.plist
	rm ${TMPDIR}/system-config-darwin.sh

system-config: system-config-generate system-config-$(PLATFORM)

uninstall-unsupported:
	@echo Failed to detect platform or platform unsupported
	@echo Uninstall system configuration manually
	exit 1

uninstall-darwin:
	exit 1

uninstall: uninstall-$(PLATFORM)

start: build
	docker compose up -d

stop:
	docker compose down

clean:
	-docker compose down -v
	rm -f ./system-config/ca.crt
	rm -f ./system-config/docker.gateway

.PHONY: build ca-extract ca-install-unsupported ca-install-darwin ca-install system-config-generate system-config-unsupported system-config-darwin system-config uninstall-unsupported uninstall-darwin uninstall stop start clean
