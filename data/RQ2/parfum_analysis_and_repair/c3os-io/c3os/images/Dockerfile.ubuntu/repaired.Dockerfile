ARG BASE_IMAGE=ubuntu:20.04

FROM $BASE_IMAGE
ARG K3S_VERSION

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:oibaf/test
RUN apt update
RUN apt install --no-install-recommends -y \
	systemd \
        grub-pc-bin \
        grub-efi-amd64-bin \
        grub2 \
        grub2-common \
        nohang \
	grub2-common \
        sudo \
	iproute2 \
	squashfs-tools \
	parted dracut \
	dracut-network tar \
	e2fsprogs \
	dosfstools \
	coreutils \
        network-manager \
	debianutils \
	curl \
	openssh-server \
        nano \
	gawk \
	haveged \
	rsync \
        linux-image-generic && apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV INSTALL_K3S_VERSION=${K3S_VERSION}
ENV INSTALL_K3S_BIN_DIR="/usr/bin"
RUN curl -sfL https://get.k3s.io > installer.sh
RUN INSTALL_K3S_SKIP_START="true" INSTALL_K3S_SKIP_ENABLE="true" bash installer.sh
RUN INSTALL_K3S_SKIP_START="true" INSTALL_K3S_SKIP_ENABLE="true" bash installer.sh agent
RUN rm -rf installer.sh
RUN ln -s /usr/sbin/grub-install /usr/sbin/grub2-install
RUN systemctl enable nohang-desktop.service
RUN systemctl enable ssh
RUN systemctl enable NetworkManager.service
RUN echo "auto lo" > /etc/network/interfaces
RUN echo "iface lo inet loopback" >> /etc/network/interfaces

# Fixup sudo perms
RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

# Setup auto network on ubuntu
RUN sed -i 's/managed=false/managed=true/g' /etc/NetworkManager/NetworkManager.conf
RUN touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
