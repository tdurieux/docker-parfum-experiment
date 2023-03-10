FROM centos:7
MAINTAINER Michael J. Stealey <stealey@renci.org>

ENV SLURM_VERSION=19.05.1

RUN yum -y install \
  deltarpm \
  epel-release \
  && yum -y install \
  which \
  wget \
  munge \
  munge-libs \
  munge-devel \
  rpm-build \
  gcc \
  openssl \
  openssl-devel \
  libssh2-devel \
  pam-devel \
  numactl \
  numactl-devel \
  hwloc \
  hwloc-devel \
  lua \
  lua-devel \
  readline-devel \
  rrdtool-devel \
  ncurses-devel \
  gtk2-devel \
  man2html \
  libibmad \
  libibumad \
  perl-Switch \
  perl-ExtUtils-MakeMaker \
  mariadb-server \
  mariadb-devel \
  && yum -y group install "Development Tools" && rm -rf /var/cache/yum

COPY docker-entrypoint.sh /docker-entrypoint.sh
VOLUME ["/packages"]
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["ls", "-alh", "/packages"]
