FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# --- 3. Enterprise Tools ---
RUN apt-get install -y \
    sudo \
    openssh-server \
    net-tools \
    iproute2 \
    pciutils \
    lvm2 \
    nfs-common \
    ceph-common \
    zfsutils-linux \
    open-iscsi \
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
    ansible

# --- 5. Add Filebeat (Elastic's repo) ---
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" > /etc/apt/sources.list.d/elastic-8.x.list && \
    apt-get update && \
    apt-get install -y filebeat

# --- 1. Proxmox Repository Setup ---
RUN apt-get update && \
    apt-get install -y gnupg curl wget lsb-release ca-certificates && \
    echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list && \
    curl -fsSL https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

# --- 2. Install Proxmox VE (with all storage backends) ---
# This brings in kernel, initrd, ZFS, Ceph, LVM, NFS, etc.
RUN apt-get update && \
    apt-get install -y proxmox-ve

# --- 6. Configure root password and SSH ---
RUN echo "root:changeme" | chpasswd
# SSH will run by default due to Proxmox packages (but you may want to enable/override configs if needed)

# --- 7. Clean up ---
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# --- 8. Default systemd entrypoint (for WW4 netboot) ---
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
