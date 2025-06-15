<img src="https://www.ualberta.ca/en/toolkit/media-library/homepage-assets/ua_logo_green_rgb.png" alt="University of Alberta Logo" width="50%" />

# Proxmox VE Node Image for Warewulf

[![CI/CD](https://github.com/ualberta-rcg/warewulf-proxmox/actions/workflows/deploy-warewulf-proxmox.yml/badge.svg)](https://github.com/ualberta-rcg/warewulf-proxmox/actions/workflows/deploy-warewulf-proxmox.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/rkhoja/warewulf-proxmox?style=flat-square)
![Docker Image Size](https://img.shields.io/docker/image-size/rkhoja/warewulf-proxmox/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)

**Maintained by:** Rahim Khoja ([khoja1@ualberta.ca](mailto:khoja1@ualberta.ca)) & Karim Ali ([kali2@ualberta.ca](mailto:kali2@ualberta.ca))

## 🧰 Description

This repository contains a minimal but functional **Proxmox VE node image** built on Debian Bookworm, packaged into a Docker container that is **Warewulf-compatible** and deployable on bare metal.

It's primarily used for imaging and provisioning compute nodes in HPC or virtualized environments using [Warewulf 4](https://warewulf.org), and is tailored to interoperate with Proxmox VE and common enterprise tools.

The image is automatically built and pushed to Docker Hub using GitHub Actions whenever changes are pushed to the `latest` branch.

## 📦 Docker Image

**Docker Hub:** [rkhoja/warewulf-proxmox\:latest](https://hub.docker.com/r/rkhoja/warewulf-proxmox)

```bash
docker pull rkhoja/warewulf-proxmox:latest
```

## 🏗️ What's Inside

This container includes:

* **Proxmox VE** (from the no-subscription repo)
* SSH, LVM, NFS, smartmontools, ipmitool, sensors
* Python 3 and Ansible for automation
* Configured for `/sbin/init` boot (Warewulf default entrypoint)

It also sets a root password to `changeme` (please change it in production setups).

## 🛠️ GitHub Actions - CI/CD Pipeline

This project includes a GitHub Actions workflow: `.github/workflows/deploy-warewulf-proxmox.yml`.

### 🔄 What It Does

* Builds the Docker image from the `Dockerfile`
* Logs into Docker Hub using stored GitHub Secrets
* Pushes the image tagged as the current branch (usually `latest`)

### ✅ Setting Up GitHub Secrets

To enable pushing to your Docker Hub:

1. Go to your fork's GitHub repo → **Settings** → **Secrets and variables** → **Actions**
2. Add the following:

   * `DOCKER_HUB_REPO` → your Docker Hub repo. In this case: *rkhoja/warewulf-proxmox* 
   * `DOCKER_HUB_USER` → your Docker Hub username
   * `DOCKER_HUB_TOKEN` → create a [Docker Hub access token](https://hub.docker.com/settings/security)

### 🚀 Manual Trigger & Auto-Build

* Manual: Run the workflow from the **Actions** tab with **Run workflow** (enabled via `workflow_dispatch`).
* Automatic: Any push to the `latest` branch triggers the CI/CD pipeline.

* **Recommended branching model:**
  * Work and test in `main`
  * Merge or fast-forward `main` to `latest` to trigger a production build

```bash
git checkout latest
git merge main
git push origin latest
```

## 🧪 How To Use This Image with Warewulf 4

Once you have Warewulf 4 setup on your control node:

```bash
warewulf import docker rkhoja/warewulf-proxmox:latest --name=proxmox-node
```

Then assign the image to a compute node:

```bash
wwctl node set n00[1-4] --container=proxmox-node
wwctl configure -a
```

Finally boot the nodes via PXE.

## 🤝 Support

Many Bothans died to bring us this information. This project is provided as-is, but reasonable questions may be answered based on my coffee intake or mood. ;)

Feel free to open an issue or email **[khoja1@ualberta.ca](mailto:khoja1@ualberta.ca)** or **[kali2@ualberta.ca](mailto:kali2@ualberta.ca)** for U of A related deployments.

## 📜 License

This project is released under the **MIT License** - one of the most permissive open-source licenses available.

**What this means:**
- ✅ Use it for anything (personal, commercial, whatever)
- ✅ Modify it however you want
- ✅ Distribute it freely
- ✅ Include it in proprietary software

**The only requirement:** Keep the copyright notice somewhere in your project.

That's it! No other strings attached. The MIT License is trusted by major projects worldwide and removes virtually all legal barriers to using this code.

**Full license text:** [MIT License](./LICENSE)

## 🧠 About University of Alberta Research Computing

The [Research Computing Group](https://www.ualberta.ca/en/information-services-and-technology/research-computing/index.html) supports high-performance computing, data-intensive research, and advanced infrastructure for researchers at the University of Alberta and across Canada.

We help design and operate compute environments that power innovation — from AI training clusters to national research infrastructure.
