FROM quay.io/centos/centos:stream9

# System dependent

ARG TZ
ENV TZ=${TZ}

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    && dnf -y update \
    && dnf -y groupinstall "Development Tools" \
    && dnf -y install \
    sudo \
    openssh-server \
    rsyslog \
    rsync wget curl-minimal \
    langpacks-ja \
    openssl-devel \
    postgresql-devel \
    postgresql \
    postgresql-server \
    libacl-devel \
    ruby \
    perl-bignum \
    hostname \
    zlib-devel libedit-devel pam-devel \
    nc ldns iproute net-tools bind-utils telnet tcpdump \
    gdb strace valgrind libtsan \
    man man-pages man-db which \
    nano emacs-nox less \
    'dnf-command(debuginfo-install)' \
    && sed -i 's@^Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin$@Defaults    secure_path = /usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin@' /etc/sudoers \
    && cd /root \
    && GCT=gct-6.2.1629922860 \
    && GCT_PKG=${GCT}.tar.gz \
    && wget https://repo.gridcf.org/gct6/sources/${GCT_PKG} \
    && tar xvf ${GCT_PKG} \
    && cd ${GCT} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
       --sysconfdir=/etc \
       --prefix=/usr/local \
    && make -j globus_proxy_utils globus_gsi_cert_utils globus_gssapi_gsi globus_simple_ca gsi-openssh myproxy \
    && make install \
    && cd .. \
    && git clone --depth 1 \
       -b fuse-2.9.9 https://github.com/libfuse/libfuse.git \
    && cd libfuse \
    && ./makeconf.sh \
    && sed -i -e 's/closefrom(/closefrom0(/g' util/ulockmgr_server.c \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install

### not found
# fuse-devel (version 2.x)
# globus-gssapi-gsi-devel (gct)
# dnf debuginfo-install -y fuse-libs

# System independent (see setup-univ.sh)

ARG GFDOCKER_USERNAME_PREFIX
ARG GFDOCKER_PRIMARY_USER
ARG GFDOCKER_NUM_GFMDS
ARG GFDOCKER_NUM_GFSDS
ARG GFDOCKER_NUM_USERS
ARG GFDOCKER_HOSTNAME_PREFIX_GFMD
ARG GFDOCKER_HOSTNAME_PREFIX_GFSD
ARG GFDOCKER_HOSTNAME_SUFFIX
ARG GFDOCKER_USE_SAN_FOR_GFSD
COPY . /tmp/gfarm
COPY gfarm2fs /tmp/gfarm2fs
RUN "/tmp/gfarm/docker/dev/common/setup-univ.sh"

CMD ["/sbin/init"]
