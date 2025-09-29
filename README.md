# 🛠️ Scripts Collection

This repository contains a set of shell scripts for managing Linux servers, Docker environments, and Kubernetes clusters.  
The scripts are primarily written for **Debian-based** systems and cover tasks such as service management, software installation, and automation helpers.

---

## 📜 Available Scripts

| Script name                | Description |
|---------------------------|-------------|
| `argocdinstall.sh`        | Installs Argo CD into a Kubernetes cluster. |
| `ban.sh`                  | Blocks IP addresses on specific ports using `firewalld`. |
| `check.sh`                | Lists running services, Docker containers, and locates Compose files. |
| `create.sh`               | Clones Proxmox virtual machines from a template. |
| `debian12dockerinstall.sh`| Installs Docker on Debian 12. |
| `debian2fagoogle.sh`      | Configures SSH 2FA with Google Authenticator. |
| `docker2debian11install.sh`| One-liner Docker & optional Rancher install. |
| `docker_menu.sh`          | Interactive menu for starting/stopping containers. |
| `dockerclean.sh`          | Stops & removes all Docker containers. |
| `dockerk3s_menu.sh`       | Menu interface for Docker + K3s management. |
| `dockeroneliner.sh`       | Minimal script to install Docker. |
| `getvmips.sh`             | Lists Proxmox VM IPs for Ansible inventories. |
| `jitsi-install.sh`        | Installs and configures Jitsi Meet. |
| `k3s-reinstall.sh`        | Uninstalls & reinstalls a K3s cluster. |
| `k3s_grafana.sh`          | Sets up K3s with etcd and Grafana stack. |
| `k3s_helm_install.sh`     | Installs K3s and Helm. |
| `kepernyo.sh`             | Turns display on/off with `vbetool`. |
| `kill.sh`                 | Stops and removes a Proxmox VM by ID. |
| `nagios-install.sh`       | Installs Nagios Core and plugins. |
| `pkgman.sh`               | Installs Homebrew, Nala, and package tools. |
| `portainer.sh`            | Deploys Portainer with MariaDB & Nginx Proxy Manager. |
| `proxmoxdarktheme.sh`     | Installs PVEDiscordDark theme on Proxmox. |
| `rancher.sh`              | Runs Rancher server and shows bootstrap password. |
| `services.sh`             | Generates HTML report of services & Compose stacks. |
| `set_hostname.sh`         | Interactive hostname changer. |
| `set_static_ip.sh`        | Configures static IP for current interface. |
| `setup_python_venv.sh`    | Creates and activates Python virtualenv. |
| `fts.sh`                  | Performs initial Debian setup: updates system, sets hostname, and configures static IP automatically. |


---

## ⚠️ Usage Notes

All scripts are self‑contained.  
**Please review each script before running** and adjust variables for your environment.

---

## 💬 Contributions

Feel free to open issues or pull requests if you have improvements or fixes!

---

_Linux rulez 🤘 – Powered by Debian, bash, and pure automation._
