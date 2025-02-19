# Stack

Local Ingress is primarily built upon the great work of other open source
initiatives.  The stack consists of 5 services that make this possible.

* **Traefik** - Ingress service.
* **Step CA** - Certificate manager and ACME provider.
* **ACME DNS** - ACME DNS challenge service.
* **CoreDNS** - Primary DNS forwarder.
* **DNS Zone** - Simple ACME DNS HTTP storage service and DNS Zone template engine.

## Ingress

Traefik proxy provides all ingress functionality.  Services are automatically discovered and the configuration loaded via the [Docker provider](https://doc.traefik.io/traefik/providers/docker/).  The Traefik Docker provider uses container labels to retrieve routing configuration, service port, TLS configuration (optional), etc.

Local Ingress disables containers by default from being attached to the Traefik proxy.  As it is common for projects/services to include a number of internal support services (e.g. database, cache, queues, etc.), many containers for a project should not be exposed.  Only those containers that should be exposed via Traefik will be explicity marked via container labels.

Local Ingress exposes the following ports:

* **80 (HTTP)** - Unencrypted HTTP traffic.  Also used for ACME HTTP-01 challeneges by Traefik and Step CA.
* **443 (HTTPS)** - TLS encrypted HTTP traffic.
* **8080 (HTTP Alt)** - Traefik proxy dashboard.

Provided By: [Traefik](https://traefik.io/traefik/)

## PKI

A simple PKI, consisting of Root and Intermediate CAs, is created on your system.  For security, no PKI artifacts or key material exists staically or is provided by Local Ingress.  At any time this PKI can be re-created by stopping the stack and destroying the container volumes.  The stack will reinitialize and create a new PKI.

Provided By: [Step CA](https://smallstep.com/docs/step-ca/)

## DNS

DNS is what makes Local Ingress possible across various project/service repositories.  DNS must be resolvable from the host system as well as within each container.  The host configuration makes it possible for the default Docker DNS resolver to expose the zone without any additional DNS overrides in each project/service.

The stack DNS resolver is configured on the host as a resolver for the zone (default `.test`).

Provided By: [CoreDNS](https://coredns.io/), [ACME DNS](https://github.com/joohoi/acme-dns), and DNS Zone