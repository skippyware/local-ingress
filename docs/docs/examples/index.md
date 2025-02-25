# Examples

The following is a collection of some exmaple use cases for services with Local Ingress.  To integrate with Local Ingress, a compose file needs to define the shared ingress network and define Traefik container lables to define the routing.

## Define the Ingress Network

All projects and services that use Local Ingress must define the shared bridge network.  This is required so that Traefik can forward to the container when proxying tarffic/requests.

!!! note

    The shared bridge network will be created if it doesn't exist.  The shared bridge network will fail to remove if any other container is still attached to the network.  This is expected behavior and should not be cause for concern.

```yaml title="docker-compose.yml"
networks:
  ingress-net:
    name: ingress-net
```

The network has a defined name so that Docker Compose does not assign an auto-generated name based on the project/directory.

## Add Service Labels

Traefik uses service labels to add services, define routes, and manage certificates (if requested).  The stack defines identifiers for the following:

* **entrypoints** - `web` (HTTP) and `websecure` (HTTPS)
* **certresolver** - `default` (supports HTTP-01 and DNS-01 challenegs)
* **network** - `ingress-net`

!!! note

    Each service should define a unique router and service name.  It is suggested to namespace them by project name for uniqueness.

The following shows a simple example to expose a service at the URL `https://app.example.test`.

```yaml title="docker-compose.yml"
services:
  app:
    labels:
      - "traefik.enable=true"  # expose this service via traefik
      - "traefik.http.routers.example-app.rule=Host(`app.example.test`)"
      - "traefik.http.routers.example-app.entrypoints=websecure"
      - "traefik.http.routers.example-app.tls=true"
      - "traefik.http.routers.example-app.tls.certresolver=default"
      - "traefik.http.routers.example-app.service=example-app"
      - "traefik.http.services.example-app.loadbalancer.server.port=80"  # the port the service listens on internally
      - "traefik.docker.network=ingress-net"
    networks:
      - default  # include any other docker networks first
      - ingress-net  # include ingress-net last
```
