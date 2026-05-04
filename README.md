#  Podman Rootless Container Deployment on RHEL

![RHEL](https://img.shields.io/badge/RHEL-9-red?style=flat-square&logo=redhat)
![Podman](https://img.shields.io/badge/Podman-4.x-purple?style=flat-square)
![SELinux](https://img.shields.io/badge/SELinux-Enforcing-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

##  Overview

This project demonstrates a **production-grade rootless container deployment** using Podman on RHEL 9, eliminating the need for Docker daemon and root privileges — improving security in enterprise Linux environments.

##  Architecture
```
RHEL 9 Server
│
└── appuser (non-root)
    │
    ├── 🦭 Podman Pod: myapp-pod
    │   ├──  webapp container  (port 8080)
    │   └──   postgres container (port 5432)
    │
    ├──   systemd (user-level services)
    │   └── Auto-start | Auto-restart | Monitoring
    │
    ├──  SELinux (Enforcing mode)
    │   └── Volume context labels (:Z)
    │
    └──  loginctl linger
        └── Runs containers even after logout
```

##  Tech Stack

| Tool | Purpose |
|------|---------|
| **Podman 4.x** | Daemonless container runtime |
| **RHEL 9** | Enterprise Linux host |
| **Containerfile** | Custom image definition |
| **Podman Pods** | Multi-container grouping |
| **systemd** | Service management & auto-restart |
| **SELinux** | Mandatory access control |

##  Key Features

- **Rootless execution** — No root privileges required
- **No Docker daemon** — Podman is daemonless
- **SELinux enforcing** — Full MAC security
- **systemd integration** — Auto-start on boot, restart on failure
- **Multi-container pods** — webapp + postgres in same pod
- **Linger enabled** — Containers survive user logout

##  Quick Start

### Prerequisites
- RHEL 8 or 9 server
- sudo access for initial setup

### 1. Clone Repository
```bash
git clone https://github.com/yourusername/podman-rootless-deployment.git
cd podman-rootless-deployment
```

### 2. Run Setup (as root/sudo)
```bash
sudo bash scripts/setup.sh
```

### 3. Deploy (as appuser)
```bash
su - appuser
cd podman-rootless-deployment
bash scripts/deploy.sh
```

### 4. Verify
```bash
podman pod ps
podman ps
curl http://localhost:8080
systemctl --user status pod-myapp-pod.service
```

##  Screenshots

 <img width="748" height="124" alt="image" src="https://github.com/user-attachments/assets/74291fb2-450e-40e7-820b-628032d98672" />


##  Security Highlights

- Containers run as UID 1001 (non-root)
- SELinux Z-labels on all volume mounts
- No privileged ports (using 8080 instead of 80)
- No Docker socket exposure
- Network isolation via Podman CNI

##  Project Structure
```
podman-rootless-deployment/
├── Containerfile          # Custom image
├── app/index.html         # Web application
├── scripts/
│   ├── setup.sh           # Initial setup
│   ├── deploy.sh          # Deployment
│   └── cleanup.sh         # Cleanup
├── systemd/               # Systemd unit files
└── docs/                  # Documentation
```

## Author
Ajay Chaturvedi
