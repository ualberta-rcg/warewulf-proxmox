FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# --- 1. Enterprise Tools ---
RUN apt-get update && apt-get install -y \
    sudo \
    openssh-server \
    net-tools \
    iproute2 \
    pciutils \
    lvm2 \
    nfs-common \
    multipath-tools \
    ifupdown \
    rsync \
    curl \
    vim \
    tmux \
    less \
    htop \
    sysstat \
    cron \
    ipmitool \
    smartmontools \
    lm-sensors \
    python3 \
    python3-pip \
    ansible

# --- 2. Proxmox Repository Setup ---
RUN apt-get update && \
    apt-get install -y gnupg curl wget lsb-release ca-certificates && \
    echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list && \
    curl -fsSL https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

# --- 3. Install Proxmox VE (with all storage backends) ---
# This brings in kernel, initrd, ZFS, Ceph, LVM, NFS, etc.
RUN apt-get update && \
    apt-get install -y proxmox-ve

# --- 4. Configure root password and SSH ---
RUN echo "root:changeme" | chpasswd
# SSH will run by default due to Proxmox packages (but you may want to enable/override configs if needed)

# --- 5. Clean up ---
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# --- 6. Default systemd entrypoint (for WW4 netboot) ---
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
