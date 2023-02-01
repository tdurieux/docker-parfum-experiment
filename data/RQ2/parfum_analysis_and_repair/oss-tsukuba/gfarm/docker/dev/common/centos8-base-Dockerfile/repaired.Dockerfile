#FROM centos:8
FROM quay.io/centos/centos:stream8

# System dependent

ARG TZ
ENV TZ=${TZ}

RUN dnf -y update \
    && dnf -y install \
    sudo \
    openssh-server \
    rsyslog \
    rsync \
    langpacks-ja \
    && dnf -y groupinstall "Development Tools" \
    && dnf -y install \
    epel-release \
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
    && dnf -y --enablerepo=epel install \
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