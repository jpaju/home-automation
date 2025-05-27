# NixOS home automation

This repository contains [NixOS](https://nixos.org/) configuration for home automation system with [home assistant](https://www.home-assistant.io/)

## Dependency updates

This repository uses [Renovate](https://www.mend.io/mend-renovate/) for automatic dependency updates of both Nix packages and docker images.
View pending updates on the [renovate dashboard](https://developer.mend.io/github/jpaju/home-automation).

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

### Data persistence

Necessary state from the docker containers is stored in the `/srv/` folder on the host system.
Subfolders like `/srv/home-assistant/` and `/srv/zigbee2mqtt/` are mounted to their respective docker containers.

### Viewing logs

To view logs from the home-automation service:

```bash
# View recent logs in real-time
journalctl --unit home-automation --limit=50 --follow
```

### Updating versions

This repository uses docker compose to run home automation services. When version updates occur:

1. Renovate automatically creates PRs to update versions in the `docker-compose.yml` file
2. After merging updates, pull the changes to your local repository:
   ```bash
   git pull
   ```
3. Apply the new versions by reloading the service:
   ```bash
   systemctl reload home-automation
   ```

This will pull the updated Docker images and recreate the containers with the new versions.

### Mikrotik configuration

#### Port forwarding

<!-- TODO: Add details on Mikrotik port forwarding configuration -->

#### Zigbee USB stick serial over network

<!-- TODO: Add details on configuring Zigbee USB stick serial over network -->

## VS Code Remote SSH

To connect to this NixOS host with VS Code Remote SSH, you must add the following setting to your VS Code `settings.json`:

```json
"remote.SSH.useLocalServer": false
```

This is required because the default shell is fish, and there's an [open issue](https://github.com/microsoft/vscode-remote-release/issues/2509) with VS Code Remote SSH and fish shell.

## Secrets management

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix). Secrets are encrypted so they can be committed to git.

### Initial setup

Make sure you have the age key setup at:

```
~/.config/sops/age/keys.txt
```

### How to edit secrets

<!-- TODO: Add instructions for editing secrets with sops-nix -->
