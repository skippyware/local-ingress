# Local Ingress

Local Ingress is an opinionated stack aimed at making it easier to run multiple containerized projects and services locally.  Local Ingress is designed to be used with the `.test` TLD (a special purpose, reserved TLD) to avoid conflict with other TLDs.

The key features are:

* **Simple** - Services are exposed on standard ports (80 - HTTP, and 443 - HTTPS) without conflict.
* **Routing** - Services define their own routes via Host, Headers, Path, Params, etc. using [Traefik](https://traefik.io/traefik/) rules.
* **DNS** - Resolve DNS on both the host and within service containers.
* **TLS** - Services can choose to expose behind HTTPS listener with automatic certificate enrollment and renewal.  Wildcard certificates are fully supported.
* **Decoupled** - Services manage their own configurations via Docker Labels.

## Why?

Developing multiple containerized projects locally requires ensuring that each service exposes itself on a different port.  With multiple services that must work together, this typically leads to configuring CORS and inter-project routing via `host.docker.internal` or adding extra hosts that resolve to `host-gateway`.  Additionally, if projects use 3rd party services that require HTTPS communications, there may be errors and warnings for mixed-content.

The goal is to allow services that reside in different project repositories (and different Docker networks) to operate in a similar manner to staging environments.  Furthermore, the local host should have the same capability to access exposed services.

## How it works

Local Ingress provides an HTTP router (Traefik), TLS certificate management (StepCA), and DNS (CoreDNS).  The Traefik Docker provider monitors the Docker API to discover service containers and the request routing rules.  If the service container requires HTTPS, the service defition can enable certificate enrollment and optionally choose any domain(s) (including wildcard domains).  The local host is configured to use the DNS service for the `.test` TLD, which Docker automatically uses in the default resursive resolver.
