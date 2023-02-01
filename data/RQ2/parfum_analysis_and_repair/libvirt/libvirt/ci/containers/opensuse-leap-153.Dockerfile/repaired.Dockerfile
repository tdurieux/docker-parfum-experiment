# THIS FILE WAS AUTO-GENERATED
#
#  $ lcitool manifest ci/manifest.yml
#
# https://gitlab.com/libvirt/libvirt-ci

FROM registry.opensuse.org/opensuse/leap:15.3

RUN zypper update -y && \
    zypper install -y \
           audit-devel \
           augeas \
           augeas-lenses \
           bash-completion \
           ca-certificates \
           ccache \
           clang \
           codespell \
           cpp \
           cppi \
           cyrus-sasl-devel \
           device-mapper-devel \
           diffutils \
           dwarves \
           ebtables \
           fuse-devel \
           gcc \
           gettext-runtime \
           git \
           glib2-devel \
           glibc-devel \
           glibc-locale \
           glusterfs-devel \
           grep \
           iproute2 \
           iptables \
           kmod \
           libacl-devel \
           libapparmor-devel \
           libattr-devel \
           libblkid-devel \
           libcap-ng-devel \
           libcurl-devel \
           libgnutls-devel \
           libiscsi-devel \
           libnl3-devel \
           libnuma-devel \
           libpcap-devel \
           libpciaccess-devel \
           librbd-devel \
           libselinux-devel \
           libssh-devel \
           libssh2-devel \
           libtirpc-devel \
           libudev-devel \
           libwsman-devel \
           libxml2 \
           libxml2-devel \
           libxslt \
           libyajl-devel \
           lvm2 \
           make \
           nfs-utils \
           ninja \
           numad \
           open-iscsi \
           parted-devel \
           perl-base \
           pkgconfig \
           polkit \
           python3-base \
           python3-docutils \
           python3-flake8 \
           python3-pip \
           python3-setuptools \
           python3-wheel \
           qemu-tools \
           readline-devel \
           rpcgen \
           rpm-build \
           sanlock-devel \
           scrub \
           sed \
           systemtap-sdt-devel \
           wireshark-devel \
           xen-devel && \
    zypper clean --all && \
    rpm -qa | sort > /packages.txt && \
    mkdir -p /usr/libexec/ccache-wrappers && \
    ln -s /usr/bin/ccache /usr/libexec/ccache-wrappers/cc && \
    ln -s /usr/bin/ccache /usr/libexec/ccache-wrappers/clang && \
    ln -s /usr/bin/ccache /usr/libexec/ccache-wrappers/gcc

RUN pip3 install --no-cache-dir meson==0.56.0

ENV LANG "en_US.UTF-8"
ENV MAKE "/usr/bin/make"
ENV NINJA "/usr/bin/ninja"
ENV PYTHON "/usr/bin/python3"
ENV CCACHE_WRAPPERSDIR "/usr/libexec/ccache-wrappers"
