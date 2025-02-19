# Installation

Local Ingress requires two configuration changes to the host system:

* **DNS Zone Reoslver** - This allows the host to send DNS queries for our zone to the stack.
* **Loopback Alias to Docker Desktop Subnet Gateway (MacOS and Windows only)** - Docker Desktop runs in a Virtual Machine on MacOS and Windows.  This allows the MacOS/Windows host to understand that Docker's magic `host-gateway` IP address is for the loopback interface.

## Build Docker Images (Optional)

This is optional as Docker Compose will build the images on first run.  It may help to do this in a separate step to better track command output.

```console
docker compose build
```

## Generate System Configuration

!!! note

    Any configuration changes to the Docker Desktop subnet will require
    an update to the host system configuration to get the correct alias
    for the loopback interface.  It isn't common for the Docker Desktop
    subnet to change unless you have a collision with a local network.

This will run a container to get the Docker `host-gateway` IP address and template out system configuration files.

=== "MacOS"

    ```console
    make system-config-generate
    ```

=== "Linux"

    ```console
    make system-config-generate
    ```

=== "Windows"

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

    **Manual**
    
    With root priviledges, open `/etc/resolver/test` and add the following:

    ```text
    nameserver 127.0.0.1
    port 1053
    ```

    **Automated**

    ```console
    cat <<EOF |
    nameserver 127.0.0.1
    port 1053
    EOF
    sudo tee /etc/resolver/test >/dev/null
    ```

=== "Linux"

    **systemd-resolved**

    With root priviledges, open `/etc/systemd/resolved.conf` and add the following:

    ```text
    [Resolve]
    DNS=127.0.0.1:1053
    Domains=~test
    ```

=== "Windows"

    ```console
    make system-config-generate
    ```

## Alias Loopback Interface

=== "MacOS"

    **Manual**

    ```console
    sudo install -g wheel -o root -m 0644 \
        ./system-config/darwin/org.user.lo0-docker-gateway-alias.plist \
        /Library/LaunchDaemons/org.user.lo0-docker-gateway-alias.plist
    ```

    ```console
    sudo launchctl load \
        /Library/LaunchDaemons/org.user.lo0-docker-gateway-alias.plist
    ```

    **Automated**

    ```console
    make system-config
    ```

=== "Linux"

    _Not required!_

=== "Windows"

    ```console
    type system-config\docker.gateway
    ```

    ```console
    netsh interface ip add address "Loopback" DOCKER_GW_ADDRESS 255.255.255.0
    ```
