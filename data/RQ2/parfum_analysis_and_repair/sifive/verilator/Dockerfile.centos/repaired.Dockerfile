FROM centos:7
RUN yum update -y && yum install -y \
  autoconf \
  bison \
  flex \
  gcc-c++ \
  git \
  glibc-static \
  libstdc++-static \
  perl-version \
  perl-Digest-MD5 \
  rsync \
  rpm-build \
  make \
  python3 && rm -rf /var/cache/yum
WORKDIR /usr/src/app
