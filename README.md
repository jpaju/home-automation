# NixOS home automation

This repository contains [NixOS](https://nixos.org/) system that hosts for home automation services
based on [Home Assistant](https://www.home-assistant.io/).

## Architecture

This system uses a hybrid approach combining NixOS for system-level configuration and Docker for home automation services:

- **NixOS** manages the host system, networking, nginx reverse proxy, and systemd services
- **Docker Compose** defines and runs the home automation services in containers
- **Data persistence** is handled by mounting `/srv/` directories from host to containers
- **Systemd** manages the Docker Compose stack as a single service unit
- **Nginx** provides SSL termination and reverse proxy to containers
- **Restic** handles automated backups of persistent data to remote storage

## External configuration

Configuration required outside of this repository on routers, network devices, and host systems.

### DNS and port forwarding

The system provides both internal (local network) and external (internet) access to services:
Internal services can only be accessed from local networks (192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12).
Only Home Assistant is accessible externally (from public internet).

**Traffic flow**: Internet/local network → router → nginx → docker containers (Home assistant, Zigbee2MQTT, etc.)

#### Internal access (local network only)

1. **DNS Configuration**: Point all domain names ending with `<internal-domain>` to this NixOS host IP.
   The specific domain names can be found in the `nginx.nix` file.
   Create an A record for one domain and use CNAME records for others, for example:
   - A record: `home-automation.<internal-domain>` → `<NixOS-host-IP>`
   - CNAME record(s): `zigbee.<internal-domain>` → `home-automation.<internal-domain>`

#### External access (internet)

2. **DNS Configuration**: The domain `hass.<external-domain>` should point to your router's public IP via dynamic DNS.

3. **Port Forwarding**: Configure your router to forward port 63719 to this NixOS host:
   - Port 63719 (HTTPS) → nginx service (used by `hass.<external-domain>`)

### Zigbee adapter serial over network

Zigbee2MQTT is configured to use a zigbee adapter via serial over network.

The configuration is located at `/srv/zigbee2mqtt/data/configuration.yaml` and contains the IP address and port of the remote zigbee adapter.

### Z-Wave USB stick passthrough

The Z-Wave JS UI container requires access to the Z-Wave device.
The docker configuration expects the Z-Wave USB device to be available at `/dev/serial/by-id/usb-Zooz_800_Z-Wave_Stick_533D004242-if00`.

**If NixOS is running as a virtualization guest:**

1. Configure the hypervisor to pass through the USB Z-Wave stick to the NixOS guest
2. Ensure the USB device appears in the guest at the expected path
3. Verify device permissions allow the docker container to access it

### Synology NAS SFTP setup

Restic requires non-interactive SFTP login for automated backups. Therefore, public key authentication must be configured.

- Generate a keypair for the **root user** on the home-automation machine
- Temporarily add the backup user to Synology's administrators group to enable SSH access
- Copy the SSH public key to Synology using: `ssh-copy-id <user>@<synology-host>`
- Remove the backup user from Synology's administrators group after setup

## NixOS configuration

### Applying system changes

When you make changes to the NixOS configuration files, you need to rebuild the system to apply changes:

```bash
nixos-rebuild switch
```

### Rolling back changes

If a new configuration causes issues, you can roll back to a previous generation:

```bash
# Roll back to the previous generation
nixos-rebuild switch --rollback

# Or list available generations
nixos-rebuild list-generations

# And switch to a specific generation (replace N with the generation number)
sudo /nix/var/nix/profiles/system-N-link/bin/switch-to-configuration switch
```

## Home automation services

### Services startup

Home automation services are configured to start automatically with systemd when the server boots up.
If you need to manually restart the services, you can use:

```bash
systemctl restart home-automation
```

### Updating versions

When updated versions of home automation services are available:

1. Renovate automatically creates PRs to update image versions in the `docker-compose.yml` file
2. After merging update PRs, pull the changes locally:
   ```bash
   git pull
   ```
3. Optionally, pre-download the updated Docker images:
   ```bash
   cd home-automation
   docker compose pull
   ```
4. Apply the new versions by reloading the service:
   ```bash
   systemctl reload home-automation
   ```

This will pull the updated Docker images and recreate the containers with the new versions.

### Data persistence

Necessary state from the docker containers is stored in the `/srv/` folder on the host system.
Subfolders like `/srv/home-assistant/` and `/srv/zigbee2mqtt/` are mounted to their respective docker containers.

### Backups

We use Restic for backups, which automatically backs up files from the `/srv` folder to a local NAS each day.

### Viewing logs

To view logs from the home-automation service:

```bash
# View recent logs in real-time
journalctl --unit home-automation --limit=50 --follow
```

## Secrets management

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix) and encrypted with age keys, allowing them to be safely committed to git.

### Prerequisites

Ensure you have the age key configured at `~/.config/sops/age/keys.txt`.

### Editing secrets

```bash
cd system/secrets
sops secrets.yaml
```

This opens the secrets file in your `$EDITOR`. Make your changes, then save and quit - the file will be automatically encrypted.

## Dependency updates

This repository uses [Renovate](https://www.mend.io/mend-renovate/) for automatic dependency updates of both Nix packages and docker images.
View pending updates on the [renovate dashboard](https://developer.mend.io/github/jpaju/home-automation).

## Development tools

### VS Code Remote SSH

To connect to this NixOS host with VS Code Remote SSH, you must add the following setting to your VS Code `settings.json`:

```json
"remote.SSH.useLocalServer": false
```

This is required because the default shell is fish, and there's an [open issue](https://github.com/microsoft/vscode-remote-release/issues/2509) with VS Code Remote SSH and fish shell.
