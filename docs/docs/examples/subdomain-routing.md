# Subdomain Routing

Expose an application that uses subdomains for routing or multi-tenancy.

This example may represent a web application that uses subdomains for a multi-tenant system.  For cases where the subdomain is not known, wildcard certificates are required.

**URL** - https://basic.test or https://subdomain.basic.test

## Service

```yaml
services:
  www:
    image: nginx:1.27-alpine
    networks:
      - default
      - ingress-net
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.basic-app.rule=HostRegexp(`basic.test`,`{subdomain:[a-z]+}.basic.test`)"
      - "traefik.http.routers.basic-app.entrypoints=websecure"
      - "traefik.http.routers.basic-app.tls=true"
      - "traefik.http.routers.basic-app.tls.certresolver=default"
      - "traefik.http.routers.basic-app.tls.domains[0].main=basic.test"
      - "traefik.http.routers.basic-app.tls.domains[0].sans=*.basic.test"
      - "traefik.http.routers.basic-app.service=basic-app"
      - "traefik.http.services.basic-app.loadbalancer.server.port=80"
      - "traefik.docker.network=ingress-net"

networks:
  ingress-net:
    name: ingress-net
```
