# Customize

Local Ingress supports some basic customization via environment variables.  Docker Compose supports a number of ways to [specify envirnment variables](https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/#ways-to-set-variables-with-interpolation).  If you plan on making a permanent change, the suggested method is to define any overrides in `.env`.

!!! warning

    Do not set the `LOCAL_INGRESS_ACME_DNS_ZONE` and `LOCAL_INGRESS_DNS_ZONE` to the same value.  As `LOCAL_INGRESS_DNS_ZONE` is the SOA for the zone, it will not allow for ACME DNS challenges to correctly verify.

!!! info

    For MacOS, it is not recommened to set the `LOCAL_INGRESS_DNS_ZONE` to `local`.  Setting to `local` may conflict with the MacOS default discovery service.

| Setting                                | Default     | Description                                                |
| -------------------------------------- | ----------- | ---------------------------------------------------------- |
| `LOCAL_INGRESS_ACME_DNS_ZONE`          | `local`     | The ACME DNS challenge zone.                               |
| `LOCAL_INGRESS_DNS_ZONE`               | `test`      | The DNS zone for all services.                             |
| `LOCAL_INGRESS_DNS_PORT`               | `1053`      | The exposed port for the DNS resolver.                     |
| `LOCAL_INGRESS_STEPCA_DEBUG`           | `0`         | Enable StepCA debug output. Enabled `1`, Disabled `0`.     |
| `LOCAL_INGRESS_DNS_PORT`               | `1053`      | The exposed port for the DNS resolver.                     |
| `LOCAL_INGRESS_TRAEFIK_LOG_LEVEL`      | `WARN`      | The Traefik log level.                                     |
| `LOCAL_INGRESS_TRAEFIK_RULE_SYNTAX`    | `v3`        | The traefik default rules syntax.                          |
