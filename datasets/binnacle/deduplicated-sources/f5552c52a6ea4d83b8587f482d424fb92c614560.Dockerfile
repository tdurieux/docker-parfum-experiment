FROM debian:jessie

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		acpi-support-base \
		bash-completion \
		busybox \
		ca-certificates \
		ifupdown \
		isc-dhcp-client \
		linux-image-3.16.0-4-amd64 \
		ntp \
		openssh-server \
		rsync \
		sudo \
		sysvinit \
		\
		sysvinit-core \
		\
		squashfs-tools \
		xorriso \
		xz-utils \
		\
		isolinux \
		syslinux-common \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /etc/ssh/ssh_host_* \
	&& mkdir -p /tmp/iso/isolinux \
	&& ln -L /usr/lib/ISOLINUX/isolinux.bin /usr/lib/syslinux/modules/bios/* /tmp/iso/isolinux/ \
	&& ln -L /usr/lib/ISOLINUX/isohdpfx.bin /tmp/ \
	&& apt-get purge -y --auto-remove \
		isolinux \
		syslinux-common

#		apparmor \
# see https://wiki.debian.org/AppArmor/HowTo and isolinux.cfg

#		curl \
#		wget \

# BUSYBOX ALL UP IN HERE
RUN set -e \
	&& busybox="$(which busybox)" \
	&& for m in $("$busybox" --list); do \
		if ! command -v "$m" > /dev/null; then \
			ln -vL "$busybox" /usr/local/bin/"$m"; \
		fi; \
	done

# if /etc/machine-id is empty, systemd will generate a suitable ID on boot
RUN echo -n > /etc/machine-id

# setup networking (hack hack hack)
# TODO find a better way to do this natively via some eth@.service magic (like the getty magic) and remove ifupdown completely
RUN for iface in eth0 eth1 eth2 eth3; do \
		{ \
			echo "auto $iface"; \
			echo "allow-hotplug $iface"; \
			echo "iface $iface inet dhcp"; \
		} > /etc/network/interfaces.d/$iface; \
	done

# COLOR PROMPT BABY
RUN sed -ri 's/^#(force_color_prompt=)/\1/' /etc/skel/.bashrc \
	&& cp /etc/skel/.bashrc /root/

# setup our non-root user, set passwords for both users, and setup sudo
RUN useradd --create-home --shell /bin/bash docker \
	&& { \
		echo 'root:docker'; \
		echo 'docker:docker'; \
	} | chpasswd \
	&& echo 'docker ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/docker

# autologin for all tty
# see also: grep ^ExecStart /lib/systemd/system/*getty@.service
RUN mkdir -p /etc/systemd/system/getty@.service.d && { \
		echo '[Service]'; \
		echo 'ExecStart='; \
		echo 'ExecStart=-/sbin/agetty --autologin docker --noclear %I $TERM'; \
	} > /etc/systemd/system/getty@.service.d/autologin.conf
RUN mkdir -p /etc/systemd/system/serial-getty@.service.d && { \
		echo '[Service]'; \
		echo 'ExecStart='; \
		echo 'ExecStart=-/sbin/agetty --autologin docker --keep-baud 115200,38400,9600 %I $TERM'; \
	} > /etc/systemd/system/serial-getty@.service.d/autologin.conf

# setup inittab for autologin too (in case of sysvinit)
RUN set -e && { \
	echo 'id:2:initdefault:'; \
	echo 'si::sysinit:/etc/init.d/rcS'; \
	for i in 0 1 2 3 4 5 6; do \
		echo "l$i:$i:wait:/etc/init.d/rc $i"; \
	done; \
	for tty in 1 2 3 4 5 6; do \
		[ $tty = 1 ] && rl=2345 || rl=23; \
		echo "$tty:$rl:respawn:/sbin/getty --autologin docker --noclear 38400 tty$tty"; \
	done; \
	for ttyS in 0; do \
		echo "T$ttyS:23:respawn:/sbin/getty --autologin docker -L ttyS$ttyS 9600 vt100"; \
	done; \
} > /etc/inittab
# TODO figure out a clean way to suppress the "respawning too fast" error so we can have ttyS1 back

# setup NTP to use the boot2docker vendor pool instead of Debian's
RUN sed -i 's/debian.pool.ntp.org/boot2docker.pool.ntp.org/g' /etc/ntp.conf

# set a default LANG (sshd reads from here)
# this prevents warnings later
RUN echo 'LANG=C.UTF-8' > /etc/default/locale

# PURE VANITY
RUN { echo; echo 'Docker (\\s \\m \\r) [\\l]'; echo; } > /etc/issue
RUN . /etc/os-release && echo "$PRETTY_NAME" > /tmp/iso/version

COPY scripts/generate-ssh-host-keys.sh /usr/local/sbin/
COPY inits/ssh-keygen /etc/init.d/
RUN update-rc.d ssh-keygen defaults

COPY scripts/initramfs-live-hook.sh /usr/share/initramfs-tools/hooks/live
COPY scripts/initramfs-live-script.sh /usr/share/initramfs-tools/scripts/live

COPY excludes /tmp/
COPY scripts/audit-rootfs.sh scripts/build-rootfs.sh scripts/build-iso.sh /usr/local/sbin/

#RUN build-iso.sh # creates /tmp/docker.iso
