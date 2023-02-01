
# kind cluster base image, based on the official Kinid base image
#
# To this we add systemd, CNI, and other tools needed to run Kubeadm
#
# For systemd + docker configuration used below, see the following references:
# https://www.freedesktop.org/wiki/Software/systemd/ContainerInterface/
# https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
# https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/

ARG BASE_IMAGE="opensuse/tumbleweed"
FROM ${BASE_IMAGE}

# NOTE: ARCH must be defined again after FROM
# https://docs.docker.com/engine/reference/builder/#scope
ARG ARCH="amd64"

# Get dependencies
# The base image already has: ssh, apt, snapd
# This is broken down into (each on a line):
# - packages necessary for installing docker
# - packages needed to run services (systemd)
# - packages needed for docker / hyperkube / kubernetes components
# - misc packages (utilities we use in our own tooling)
# Then we cleanup (removing unwanted systemd services)
# Finally we disable kmsg in journald
# https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/
RUN \
    zypper ar --refresh --enable --no-gpgcheck \
        https://download.opensuse.org/tumbleweed/repo/oss extra-repo0 \
    && zypper ref -r extra-repo0 \
    && zypper in -y --no-recommends \
        ca-certificates curl gpg2 lsb-release \
        systemd systemd-sysvinit libsystemd0 \
        conntrack-tools iptables iproute2 \
        ethtool socat util-linux ebtables udev kmod \
        bash rsync \
        docker \
        cni cni-plugins \
    && zypper clean -a \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && echo "ReadKMsg=no" >> /etc/systemd/journald.conf \
    && systemctl enable docker.service

# Install CNI binaries to /opt/cni/bin
RUN mkdir -p /opt/cni && ln -s /usr/lib/cni /opt/cni/bin

# tell systemd that it is in docker (it will check for the container env)
# https://www.freedesktop.org/wiki/Software/systemd/ContainerInterface/
ENV container docker

# systemd exits on SIGRTMIN+3, not SIGTERM (which re-executes it)
# https://bugzilla.redhat.com/show_bug.cgi?id=1201657
STOPSIGNAL SIGRTMIN+3

# wrap systemd with our special entrypoint, see pkg/build for how this is built
# basically this just lets us set up some things before continuing on to systemd
# while preserving that systemd is PID1
# for how we leverage this, see pkg/cluster
COPY [ "entrypoint/entrypoint", "/usr/local/bin/" ]

# We need systemd to be PID1 to run the various services (docker, kubelet, etc.)
# NOTE: this is *only* for documentation, the entrypoint is overridden at runtime
ENTRYPOINT [ "/usr/local/bin/entrypoint", "/sbin/init" ]

# the docker graph must be a volume to avoid overlay on overlay
# NOTE: we do this last because changing a volume with a Dockerfile must
# occur before defining it.
# See: https://docs.docker.com/engine/reference/builder/#volume
VOLUME [ "/var/lib/docker" ]

# TODO(bentheelder): deal with systemd MAC address assignment
# https://github.com/systemd/systemd/issues/3374#issuecomment-288882355
# https://github.com/systemd/systemd/issues/3374#issuecomment-339258483
