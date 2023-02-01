ARG BASE_IMAGE=opensuse/tumbleweed

ARG K3S_VERSION

FROM $BASE_IMAGE

RUN zypper ar -G https://download.opensuse.org/repositories/utilities/openSUSE_Factory/utilities.repo && zypper ref

RUN zypper in -y \
    bash-completion \
    conntrack-tools \
    coreutils \
    curl \
    device-mapper \
    dosfstools \
    dracut \
    e2fsprogs \
    findutils \
    gawk \
    gptfdisk \
    grub2-i386-pc \
    grub2-x86_64-efi \
    nohang \
    fail2ban \
    haveged \
    htop \
    iproute2 \
    iptables \
    iputils \
    issue-generator \
    jq \
    kernel-default \
    kernel-firmware-all \
    less \
    lsscsi \
    lvm2 \
    mdadm \
    multipath-tools \
    nano \
    nethogs \
    nfs-utils \
    open-iscsi \
    open-vm-tools \
    parted \
    pigz \
    policycoreutils \
    procps \
    python-azure-agent \
    qemu-guest-agent \
    rng-tools \
    rsync \
    squashfs \
    strace \
    systemd \
    systemd-sysvinit \
    tar \
    timezone \
    tmux \
    vim \
    which && zypper cc

ENV INSTALL_K3S_VERSION=${K3S_VERSION}
ENV INSTALL_K3S_BIN_DIR="/usr/bin"
RUN curl -sfL https://get.k3s.io > installer.sh
RUN INSTALL_K3S_SKIP_START="true" INSTALL_K3S_SKIP_ENABLE="true" sh installer.sh
RUN INSTALL_K3S_SKIP_START="true" INSTALL_K3S_SKIP_ENABLE="true" sh installer.sh agent
RUN rm -rf installer.sh