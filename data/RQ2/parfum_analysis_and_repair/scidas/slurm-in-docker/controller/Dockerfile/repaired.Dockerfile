FROM scidas/slurm.base:19.05.1
MAINTAINER Michael J. Stealey <stealey@renci.org>

# install openmpi 3.0.1
RUN yum -y install \
  gcc-c++ \
  gcc-gfortran \
  && yum -y localinstall \
  /packages/openmpi-*.rpm && rm -rf /var/cache/yum

# install Lmod 7.7
RUN yum -y install \
  lua-posix \
  lua \
  lua-filesystem \
  lua-devel \
  wget \
  bzip2 \
  expectk \
  make \
  && wget https://sourceforge.net/projects/lmod/files/Lmod-7.7.tar.bz2 \
  && tar -xjvf Lmod-7.7.tar.bz2 && rm -rf /var/cache/yum
WORKDIR /Lmod-7.7
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/apps \
  && make install \
  && ln -s /opt/apps/lmod/lmod/init/profile /etc/profile.d/z00_lmod.sh \
  && ln -s /opt/apps/lmod/lmod/init/cshrc /etc/profile.d/z00_lmod.csh
WORKDIR /

ENV USE_SLURMDBD=true \
  CLUSTER_NAME=snowflake \
  CONTROL_MACHINE=controller \
  SLURMCTLD_PORT=6817 \
  SLURMD_PORT=6818 \
  ACCOUNTING_STORAGE_HOST=database \
  ACCOUNTING_STORAGE_PORT=6819 \
  PARTITION_NAME=docker

# clean up
RUN rm -f /packages/slurm-*.rpm /packages/openmpi-*.rpm \
  && yum clean all \
  && rm -rf /var/cache/yum \
  && rm -f /Lmod-7.7.tar.bz2

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/tini", "--", "/docker-entrypoint.sh"]
