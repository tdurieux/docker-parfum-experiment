FROM centos:7

# System dependent

ARG TZ
ENV TZ=${TZ}

RUN sed -i -e '/override_install_langs/s/$/,ja_JP.utf8/g' /etc/yum.conf \
    && sed -i -e '/tsflags=nodocs/s/^/#/' /etc/yum.conf \
    && yum -y update \
    && yum -y reinstall glibc-common \
    && yum -y install \
    sudo \
    openssh-server \
    rsyslog \
    rsync \
    langpacks-ja \
    && yum -y groupinstall "Development Tools" \
    && yum -y install \
    epel-release \
    openssl-devel \
    postgresql-devel \
    postgresql \
    postgresql-server \
    fuse \
    fuse-devel \
    libacl-devel \
    ruby \
    && yum -y --enablerepo=epel install \
    globus-gssapi-gsi-devel \
    globus-simple-ca \
    globus-gsi-cert-utils-progs \
    globus-proxy-utils \
    myproxy \
    gsi-openssh-clients \
    && globus-version \
    && yum -y install \
    docbook-utils docbook-style-xsl libxslt \
    nc ldns iproute2 net-tools bind-utils telnet tcpdump \
    gdb valgrind strace inotify-tools \
    man man-pages man-pages-ja man-db which \
    nano emacs-nox less \
    && debuginfo-install -y \
    fuse-libs \
    && sed -i 's@^Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin$@Defaults    secure_path = /usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin@' /etc/sudoers && rm -rf /var/cache/yum


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
