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

## Add Routes and Services

For services that are already containerized or have a Docker Compose stack, use container/service labels to automate service discovery via Traefik's Docker provider.  For services running natively on your host or another non-Docker runtime, use Traefik's File provider.

### Docker

Add the `ingress-net` network to your Docker Compose stack.

```yaml
networks:
  ingress-net:
    name: ingress-net
```

Add labels to the container or service.  Name your router and service something that will not conflict with other services you plan to run.  Define the routing rule to include the host and any other rules (i.e. path, header, etc).  Finally, set the port the service running within the container listens on.

Note: There is no need to expose the port via a mapping.  Traefik will communicate directly with the service via the `ingress-net` network.

Note: You can define multiple routers and services for a single container/service.

```yaml
services:
  www:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.www-app.rule=Host(`www.test`)"
      - "traefik.http.routers.www-app.entrypoints=websecure"
      - "traefik.http.routers.www-app.tls=true"
      - "traefik.http.routers.www-app.tls.certresolver=default"
      - "traefik.http.routers.www-app.service=www-app"
      - "traefik.http.services.www-app.loadbalancer.server.port=80"
      - "traefik.docker.network=ingress-net"
```

Add the `ingress-net` network to the container/service.  If using the default Docker Compose network, ensure it is also added to the container/service so that it may communicate with other containers/services in the same stack.

```yaml
services:
  www:
    networks:
      - default
      - ingress-net
```

### File (Non-Docker Services)

Add a Traefik configuration file for each service you need to expose through the proxy in `./traefik/local-services`.  Either YAML or TOML configuration files may be used.  Traefik will watch this directory for changes to files and update routes and services accordingly.

The following is a sample YAML configuration to enroll a service running locally on the host.  This sample service is listening on loopback and port 8001.

```yaml
http:
  # Add the router
  routers:
    local-app:
      entryPoints:
        - websecure
      service: local-app
      tls:
        certResolver: default
      rule: Host(`local-app.test`)

  # Add the service
  services:
    local-app:
      loadBalancer:
        servers:
          # use the environment variable HOST_GATEWAY to resolve the Docker host gateway IP address
          - url: 'http://{{ env "HOST_GATEWAY" }}:8001'
```
