FROM fedora:32 AS python3.9

# CircleCI required tools
RUN dnf install -y \
      git \
      openssh \
      tar \
      gzip \
      gpg \
      ca-certificates \
  && dnf clean all && rm -rf /var/cache/dnf/*

# Development tools
RUN dnf install -y \
      @development-tools \
      findutils \
      zlib-devel \
      bzip2-devel \
      ncurses-devel \
      gdbm-devel \
      openssl-devel \
      sqlite-devel \
      tk-devel \
      libuuid-devel \
      readline-devel \
      libnsl2-devel \
      xz-devel \
      libffi-devel \
      wget \
  && git clone https://github.com/python/cpython.git \
  && cd cpython \
  && git checkout v3.9.0 \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && cd .. \
  && rm -rf cpython \
  && dnf install -y \
     @development-tools \
     findutils \
     zlib-devel \
     bzip2-devel \
     ncurses-devel \
     gdbm-devel \
     openssl-devel \
     sqlite-devel \
     tk-devel \
     libuuid-devel \
     readline-devel \
     libnsl2-devel \
     xz-devel \
     libffi-devel \
     wget \
  && dnf clean all && rm -rf /var/cache/dnf/*

# Other packages required for tests
RUN dnf install -y \
      bzip2 \
  && dnf clean all && rm -rf /var/cache/dnf/*

RUN pip3 install --no-cache-dir tox==3.20

WORKDIR /tmp/work
ENTRYPOINT ["/bin/bash"]
