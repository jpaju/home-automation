# Home Automation Setup

This repository contains NixOS configuration with a focus on home automation services.

## Home Automation Services

### Home Automation Services Startup

Home automation services are configured to start automatically with systemd when the server boots up.
If you need to manually restart the services, you can use:

```bash
systemctl restart home-automation
```

### Viewing Service Logs

To view logs from the home-automation service:

```bash
# View recent logs in real-time
journalctl --unit home-automation --limit=100 --follow
```

### Updating Versions

This repository uses Docker Compose for home automation services. When version updates occur:

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

#### Automatic Updates

This repository uses Mend Renovate for automatic dependency updates.
View pending updates on the [renovate dashboard](https://developer.mend.io/github/jpaju/home-automation).

## Secrets Management with sops-nix

### Initial Setup

Make sure you have the age key setup at:

```
~/.config/sops/age/keys.txt
```

### How to Edit Secrets

<!-- TODO: Add instructions for editing secrets with sops-nix -->

## Mikrotik Configuration

### Port Forwarding

<!-- TODO: Add details on Mikrotik port forwarding configuration -->

### Zigbee USB Stick Serial Over Network

<!-- TODO: Add details on configuring Zigbee USB stick serial over network -->
