# Root CA

In some cases it may be required to configure other services to trust the Local Ingress Root CA.  The Root CA may be exported from the stack by running one of the following commands:

```console
make ca-extract
```

or

```console
docker compose cp \
    --follow-link stepca:/home/step/certs/root_ca.crt \
    ./system-config/ca.crt
```
