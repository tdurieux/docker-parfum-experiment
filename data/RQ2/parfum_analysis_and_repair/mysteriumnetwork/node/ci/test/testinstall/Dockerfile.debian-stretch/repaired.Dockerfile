FROM debian:stretch

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
    && apt install --no-install-recommends -y systemd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    /lib/systemd/system/systemd-update-utmp*

# https://github.com/moby/moby/issues/1297
RUN echo resolvconf resolvconf/linkify-resolvconf boolean false | debconf-set-selections

RUN apt update && apt install --no-install-recommends -y sudo curl gnupg && rm -rf /var/lib/apt/lists/*;

VOLUME ["/sys/fs/cgroup"]

CMD ["/lib/systemd/systemd"]
