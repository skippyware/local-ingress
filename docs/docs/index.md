# Local Ingress

Local Ingress is an opinionated stack aimed at making it easier to run multiple
containerized projects and services locally.

The key features are:

* **Simple** - Services are exposed on standard ports (80 - HTTP, and 443 - HTTPS) without conflict.
* **Routing** - Services define their own routes via Host, Headers, Path, Params, etc. using [Traefik](https://traefik.io/traefik/) rules.
* **DNS** - Services can resolve DNS entries for other exposed services.
* **TLS** - Services can choose to expose behind HTTPS listener with automatic certificate enrollment and renewal.  Wildcard certificates are fully supported.
* **Decoupled** - Services manage their own configurations via Docker Labels.
