FROM docker.io/ubuntu:20.04

ENV PATH="/opt/bin:$PATH"

LABEL maintainer "OWenT <admin@owent.net>"

# EXPOSE 36000/tcp
# EXPOSE 36000/udp
EXPOSE 22/tcp
EXPOSE 22/udp

COPY . /opt/docker-setup
RUN /bin/bash /opt/docker-setup/replace-source.sh ; \
    sed -i '/^path-exclude=\/usr\/share\/man\// s|^|#|' /etc/dpkg/dpkg.cfg.d/excludes ; \
    apt update; apt install --no-install-recommends -y --reinstall apt coreutils bash sed procps; rm -rf /var/lib/apt/lists/*; \
    apt install --no-install-recommends -y man-db locales tzdata less iproute2 gawk lsof cron openssh-client openssh-server systemd; \
    apt install --no-install-recommends -y vim wget curl ca-certificates telnet iotop htop knot-dnsutils dnsutils systemd-cron; \
    apt install --no-install-recommends -y traceroute tcptraceroute tcpdump netcat-openbsd nmap nftables; \
    apt install --no-install-recommends -y systemd-coredump python3-setuptools python3-pip python3-mako perl automake gdb valgrind unzip lunzip; \
    apt install --no-install-recommends -y p7zip-full autoconf libtool build-essential pkg-config gettext asciidoc xmlto xmltoman expat; \
    apt install --no-install-recommends -y re2c gettext zlibc zlib1g chrpath; \
    locale-gen en_US.UTF-8; localectl set-locale LANG=en_GB.utf8 ; \
    timedatectl set-timezone Asia/Shanghai; \
    timedatectl set-ntp true; \
    /bin/bash /opt/docker-setup/cleanup.devtools.sh


# CMD /sbin/init