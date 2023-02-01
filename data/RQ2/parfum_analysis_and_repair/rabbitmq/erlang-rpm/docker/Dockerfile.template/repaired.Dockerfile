FROM quay.io/centos/centos:{centosfrom}

RUN yum -y update && yum clean all

RUN yum install -y \
  autoconf \


  clang \
  m4 \
  openssl-devel \
  ncurses-devel \
  rpm-build \
  tar \
  wget \
  zlib-devel \
  systemd-devel \
  make && rm -rf /var/cache/yum

RUN mkdir /build
CMD ["sh", "-c", "cd /build/build-dir-{centosfrom} && make"]
