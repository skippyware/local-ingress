# Basic HTTP

Expose a single web application on a fixed domain via HTTP (no encryption).

This example could be a static web application or monolithic application.

**URL** - http://basic.test

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
      - "traefik.http.routers.basic-app.rule=Host(`basic.test`)"
      - "traefik.http.routers.basic-app.entrypoints=web"
      - "traefik.http.routers.basic-app.service=basic-app"
      - "traefik.http.services.basic-app.loadbalancer.server.port=80"
      - "traefik.docker.network=ingress-net"

networks:
  ingress-net:
    name: ingress-net
```
