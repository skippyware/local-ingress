# Local Ingress

Local Ingress is an opinionated stack aimed at making it easier to run multiple containerized projects and services locally.  The Local Ingress stack provides an ingress proxy, DNS, and optional TLS certificate enrollment.  Local Ingress is designed to be used with the `.test` TLD (a special purpose, reserved TLD) to avoid conflict with other TLDs.  When properly configured on your host, the DNS resolver will provide seamless DNS resolution for both the host as well as any container.

Documentation: [https://skippyware.github.io/local-ingress](https://skippyware.github.io/local-ingress)

## Stack

* Traefik - Ingress proxy
* CoreDNS - DNS resolver
* StepCA - ACME certificate provider
* ACME-DNS - ACME DNS Challenge provider
* DNS Zone - ACME-DNS account storage and `.test` zone template.

## Host Requirements

* **DNS Zone Resolver** - Configure `.test` zone to resolve using `127.0.0.1:1053` (`127.0.0.1:53` for Windows).
* **Loopback IP Alias (MacOS and Windows only)** - Alias the Docker Desktop subnet gateway IP address on the loopback interface.  This is required because Docker Desktop runs within a VM on MacOS and Windows.

## Key Features

* Decoupled Service Definitions - Services manage their own ingress enrollment and Traefik routing rules.  Knowledge of other services is not required.
* TLS Certificate Management - Services that require TLS certificates are automatically enrolled in the local PKI.  Certificate domains can be controlled via Traefik rules or by specifying certificate Subject Alternative Names (SAN).
* Wildcard Certificate Support - Services that route via subdomain can generate wildcard certificates.