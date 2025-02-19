# Managing Stack

Local Ingress is a simple set of containers managed by Docker Compose.

## Start

Start the services, creating a PKI on first run.

```console
docker compose up -d
```

## Stop

Stop the services, keeping your PKI.

```console
docker compose down
```

## Rebuild/Recreate

Rebuilding is a matter of destroying the volumes and starting the stack.

```console
docker compose down -v
```
