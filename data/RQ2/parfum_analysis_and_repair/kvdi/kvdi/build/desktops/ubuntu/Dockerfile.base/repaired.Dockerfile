FROM ubuntu:latest as base-system

RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list

# Core Dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
        coreutils iputils-ping sudo software-properties-common curl net-tools zenity xz-utils apt-utils \
        dbus-x11 x11-utils alsa-utils mesa-utils libgl1-mesa-dri tigervnc-standalone-server xpra \
        systemd systemd-sysv pulseaudio pavucontrol firefox vim expect-dev mingetty ca-certificates \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && cd /usr/lib/systemd/system/sysinit.target.wants/ \
    && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
    && rm -f /usr/lib/systemd/system/multi-user.target.wants/* \
        /etc/systemd/system/*.wants/* \
        /usr/lib/systemd/system/local-fs.target.wants/* \
        /usr/lib/systemd/system/sockets.target.wants/*udev* \
        /usr/lib/systemd/system/sockets.target.wants/*initctl* \
        /usr/lib/systemd/system/basic.target.wants/* \
        /usr/lib/systemd/system/anaconda.target.wants/* \
        /usr/lib/systemd/system/plymouth* \
        /usr/lib/systemd/system/systemd-update-utmp*

# Filesystem
COPY rootfs /

# At the very least we want an isolated systemd-user process and Xvnc enabled.
# Extending images can put anything they want behind its display.
RUN chmod +x /usr/local/sbin/init && chmod +x /usr/local/sbin/fakegetty \
  && systemctl --user --global enable display.service \
  && systemctl enable user-init \
  && systemctl --user --global enable pulseaudio


WORKDIR /root
VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/usr/local/sbin/init"]