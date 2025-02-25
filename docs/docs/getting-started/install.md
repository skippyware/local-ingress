# Installation

Local Ingress requires two configuration changes to the host system:

* **DNS Zone Reoslver** - This allows the host to send DNS queries for our zone to the stack.
* **Loopback Alias to Docker Desktop Subnet Gateway (MacOS and Windows only)** - Docker Desktop runs in a Virtual Machine on MacOS and Windows.  This allows the MacOS/Windows host to understand that Docker's magic `host-gateway` IP address is for the loopback interface.

## Set DNS Resolver Port (Windows Only)

Windows DNS client rules don't support specifying a port for the nameserver.  As a result, the stack must be configured to expose DNS resolver on the standard port 53.  The compose file supports customization via environment variables.

```console
echo "LOCAL_INGRESS_DNS_PORT=53" > .env
```

## Generate System Configuration

!!! note

    Any configuration changes to the Docker Desktop subnet will require
    an update to the host system configuration to get the correct alias
    for the loopback interface.  It isn't common for the Docker Desktop
    subnet to change unless you have a collision with a local network.

This will run a container to get the Docker `host-gateway` IP address and template out system configuration files.

**Manual**

```console
docker compose run --rm --entrypoint='' --no-deps \
    -v "${PWD}/system-config:/system-config" \
    -v "${PWD}/dns-zone/system-config.sh:/system-config.sh" \
    -w /system-config dns-zone /system-config.sh
```

**Automated**

```console
make system-config-generate
```

Generated files:
    
| File                                                           | Description                                                        |
| -------------------------------------------------------------- | ------------------------------------------------------------------ |
| `system-config/docker.gateway`                                 | Docker Desktop subnet gateway IP address                           |
| `system-config/darwin/org.user.lo0-docker-gateway-alias.plist` | MacOS launch definition to alias the loopback interface on restart |

## Add DNS Resolver

=== "MacOS"

    Add a DNS rule to use the stack resolver for all `.test` domains.

    **Manual**
    
    With root priviledges, open `/etc/resolver/test` and add the following:

    ```text
    nameserver 127.0.0.1
    port 1053
    ```

    -OR-

    **Automated**

    ```console
    cat <<EOF |
    nameserver 127.0.0.1
    port 1053
    EOF
    sudo tee /etc/resolver/test >/dev/null
    ```

=== "Linux"

    Add a DNS rule to use the stack resolver for all `.test` domains.

    **systemd-resolved**

    With root priviledges, open `/etc/systemd/resolved.conf` and add the following:

    ```text
    [Resolve]
    DNS=127.0.0.1:1053
    Domains=~test
    ```

=== "Windows"

    Add a DNS rule to use the stack resolver for all `.test` domains.  This will require Administrator priviledges.

    ```console
    Add-DnsClientNrptRule -Namespace ".test" -NameServers "127.0.0.1" -Comment "Local Ingress DNS Resolver"
    ```

## Alias Loopback Interface

=== "MacOS"

    MacOS will clear the loopback IP alias on restart.  The following steps will add a launch daemon definition to alias the Docker Desktop gateway IP address on boot.

    **Manual**

    Install the launch daemon definition.

    ```console
    sudo install -g wheel -o root -m 0644 \
        ./system-config/darwin/org.user.lo0-docker-gateway-alias.plist \
        /Library/LaunchDaemons/org.user.lo0-docker-gateway-alias.plist
    ```

    Load the launch daemon.

    ```console
    sudo launchctl load \
        /Library/LaunchDaemons/org.user.lo0-docker-gateway-alias.plist
    ```

    -OR-

    **Automated**

    ```console
    make system-config
    ```

=== "Linux"

    Not required!  Docker doesn't run inside a Virtual Machine on Linux.  The Docker bridge network is directly reachable.

=== "Windows"

    Print the Docker Desktop gateway IP address.

    ```console
    type system-config\docker.gateway
    ```

    Add an alias for the Docker Desktop gateway IP address to the Loopback interface.  This will require Administrator priviledges.

    ```console
    netsh interface ip add address "Loopback" DOCKER_GW_ADDRESS 255.255.255.255
    ```
