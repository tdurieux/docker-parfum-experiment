FROM fedora:33

# System dependent

ARG TZ
ENV TZ=${TZ}

#RUN echo fastestmirror=True >> /etc/dnf/dnf.conf

RUN dnf -y update \
    && dnf -y install \
    sudo \
    openssh-server \
    rsyslog \
    rsync \
    langpacks-ja \
    && dnf -y groupinstall "Development Tools" \
    && dnf -y install \
    openssl-devel \
    postgresql-devel \
    postgresql \
    postgresql-server \
    fuse \
    fuse-devel \
    libacl-devel \
    ruby \
    hostname \
    perl-bignum \
    && dnf -y --enablerepo=updates-testing update \
    && dnf -y --enablerepo=updates-testing install \
    globus-gssapi-gsi-devel \
    globus-simple-ca \
    globus-gsi-cert-utils-progs \
    globus-proxy-utils \
    myproxy \
    gsi-openssh-clients \
    && globus-version \
    && dnf -y install \
    nc ldns iproute net-tools bind-utils telnet tcpdump \
    gdb strace valgrind inotify-tools libtsan procps-ng \
    man man-pages man-db which \
    nano emacs-nox less \
    && dnf install 'dnf-command(debuginfo-install)' \
    && dnf debuginfo-install -y \
    fuse-libs \
    && sed -i 's@^Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin$@Defaults    secure_path = /usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin@' /etc/sudoers


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