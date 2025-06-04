# Scripts Repository

This repository contains various shell scripts for system administration tasks and automation. Below is a brief description of each script.

## Shell scripts
- `argocdinstall.sh` - Installs ArgoCD into a Kubernetes cluster and prints the initial admin password.
- `ban.sh` - Blocks IP addresses listed in `blocked_ips.txt` on ports 80 and 443 using firewalld.
- `check.sh` - Displays running systemd services and Docker containers.
- `create.sh` - Clones a template VM on Proxmox multiple times.
- `debian12dockerinstall.sh` - Installs Docker on Debian 12 following the official instructions.
- `debian2fagoogle.sh` - Enables SSH two-factor authentication using Google Authenticator on Debian.
- `docker2debian11install.sh` - Notes for installing Docker and Rancher on Debian 11.
- `docker_menu.sh` - Menu-driven helper to list, start, and stop Docker containers.
- `dockerclean.sh` - Stops and removes all Docker containers.
- `dockerk3s_menu.sh` - Interactive dialog menu to manage Docker containers and a k3s cluster.
- `dockeroneliner.sh` - Convenience one-liner to install Docker via get.docker.com.
- `getvmips.sh` - Queries the Proxmox API for VM IPs and writes an Ansible inventory.
- `jitsi-install.sh` - Installs Jitsi Meet on Debian and obtains Let's Encrypt certificates.
- `k3s-reinstall.sh` - Uninstalls and reinstalls k3s, then checks node and pod status.
- `k3s_grafana.sh` - Sets up k3s with etcd snapshots and installs monitoring via Helm and Grafana.
- `k3s_helm_install.sh` - Example script for installing k3s, Helm, and deploying NATS.
- `kepernyo.sh` - Turns the display on or off using `vbetool`.
- `kill.sh` - Stops, unlocks, and destroys a Proxmox VM by ID.
- `nagios-install.sh` - Compiles and installs Nagios Core and plugins from source.
- `pkgman.sh` - Bootstraps Homebrew and installs Nala package manager.
- `portainer.sh` - Runs Portainer and sets up MariaDB and Nginx Proxy Manager with Docker Compose.
- `proxmoxdarktheme.sh` - Installs the PVEDiscordDark theme for Proxmox.
- `rancher.sh` - Starts a Rancher container and displays the bootstrap password.
- `services.sh` - Generates an HTML page listing Docker Compose and system service statuses.
- `set_hostname.sh` - Changes the system hostname using `hostnamectl`.
- `set_static_ip.sh` - Configures a static IP in `/etc/network/interfaces`.
- `setup_python_venv.sh` - Installs Python if needed and creates a virtual environment.

## Python
- `list_nemethge_repos.py` - Retrieves all public repositories for GitHub user
  `nemethge` using the GitHub API (supports pagination and optional
  `GITHUB_TOKEN` authentication).
