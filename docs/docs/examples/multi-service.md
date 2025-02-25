# Multi Service

Expose two web applications on the same domain using path routing.

This example may represent a web application with the frontend and backend split into different projects.  This example will route requests to `/api/*` to the backend service, while all other requests go to the frontend service.

**URL** - https://basic.test

## Frontend Service

```yaml
services:
  www:
    image: nginx:1.27-alpine
    networks:
      - default
      - ingress-net
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.frontend-basic-app.rule=Host(`basic.test`)"
      - "traefik.http.routers.frontend-basic-app.entrypoints=websecure"
      - "traefik.http.routers.frontend-basic-app.tls=true"
      - "traefik.http.routers.frontend-basic-app.tls.certresolver=default"
      - "traefik.http.routers.frontend-basic-app.service=frontend-basic-app"
      - "traefik.http.services.frontend-basic-app.loadbalancer.server.port=80"
      - "traefik.docker.network=ingress-net"

networks:
  ingress-net:
    name: ingress-net
```

## Backend Service

```yaml
services:
  www:
    image: nginx:1.27-alpine
    networks:
      - default
      - ingress-net
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.backend-basic-app.rule=Host(`basic.test`) && PathPrefix(`/api`)"
      - "traefik.http.routers.backend-basic-app.entrypoints=websecure"
      - "traefik.http.routers.backend-basic-app.tls=true"
      - "traefik.http.routers.backend-basic-app.tls.certresolver=default"
      - "traefik.http.routers.backend-basic-app.service=backend-basic-app"
      - "traefik.http.services.backend-basic-app.loadbalancer.server.port=80"
      - "traefik.docker.network=ingress-net"

networks:
  ingress-net:
    name: ingress-net
```
