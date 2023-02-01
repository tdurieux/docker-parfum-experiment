FROM  ubuntu:20.04
COPY  . /austin
RUN apt-get update && \
      apt-get install --no-install-recommends -y autoconf build-essential libunwind-dev binutils-dev libiberty-dev && \
      cd /austin && \
      autoreconf --install && \
      ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
      make && \
      make install && rm -rf /var/lib/apt/lists/*;
