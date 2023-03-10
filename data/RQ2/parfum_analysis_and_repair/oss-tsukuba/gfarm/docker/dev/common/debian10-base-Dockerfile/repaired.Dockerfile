FROM debian:buster
ARG DEBIAN_FRONTEND=noninteractive

# System dependent

ARG TZ
ENV TZ=${TZ}
ARG LANG

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y --no-install-recommends install \
    systemd \
    sudo \
    openssh-server \
    rsyslog \
    rsync \
    build-essential \
    libssl-dev \
    libldap2-dev \
    libpq-dev \
    libglobus-gssapi-gsi-dev \
    pkg-config \
    postgresql \
    postgresql-client \
    libfuse-dev \
    fuse \
    libacl1-dev \
    ruby \
    git \
    globus-simple-ca \
    globus-gsi-cert-utils-progs \
    globus-proxy-utils \
    && globus-version \
    && sed -i -E "s/# (${LANG})/\1/" /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=${LANG} \
    && apt-get -y --no-install-recommends install \
    ncat ldnsutils iproute2 net-tools bind9utils telnet tcpdump \
    manpages manpages-ja man-db \
    gdb valgrind strace inotify-tools \
    vim nano emacs-nox less \
    && apt-get -y --no-install-recommends install software-properties-common \
    && add-apt-repository 'deb http://debug.mirrors.debian.org/debian-debug/ buster-debug main' \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
    libfuse2-dbgsym \
    && systemctl disable unattended-upgrades && rm -rf /var/lib/apt/lists/*;


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
