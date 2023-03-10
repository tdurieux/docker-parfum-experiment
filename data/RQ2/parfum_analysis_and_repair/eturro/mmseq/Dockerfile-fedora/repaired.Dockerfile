FROM fedora:30

RUN dnf -y upgrade \
  && dnf -y install \
  --setopt=tsflags=nodocs \
  # Build dependency
  armadillo-devel \
  boost-devel \
  gcc-c++ \
  gsl-devel \
  htslib-devel \
  make \
  zlib-devel \
  # Testing dependency
  git-core \
  && dnf clean all

WORKDIR /work
COPY . .