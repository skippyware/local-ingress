# Getting Started

1. Clone the Local Ingress repository.

```console
git clone https://github.com/skippyware/local-ingress && cd local-ingress
```

2. Follow the [installation instructions](./install.md) for your system.
3. Start the stack.
   
```console
docker compose up -d
```

4. Add `ingress-net` network to projects/services compose file.
   
```yaml
networks:
  ingress-net:
    name: ingress-net
```

5. Add container labels and attach containers to projects/services compose file.

```yaml
services:
  app:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.example-app.rule=Host(`app.example.test`)"
      - "traefik.http.routers.example-app.entrypoints=websecure"
      - "traefik.http.routers.example-app.tls=true"
      - "traefik.http.routers.example-app.tls.certresolver=default"
      - "traefik.http.routers.example-app.service=example-app"
      - "traefik.http.services.example-app.loadbalancer.server.port=80"
      - "traefik.docker.network=ingress-net"
    networks:
      - default  # include any other docker networks first
      - ingress-net  # include ingress-net last
```

6. Start projects/services.

7. Access your project/service via the ingress: [https://app.example.test](https://app.example.test)
