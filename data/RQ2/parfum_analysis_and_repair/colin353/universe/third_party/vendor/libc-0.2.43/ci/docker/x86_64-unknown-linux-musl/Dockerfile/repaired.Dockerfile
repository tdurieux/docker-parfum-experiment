FROM ubuntu:17.10

RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc make libc6-dev git curl ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://www.musl-libc.org/releases/musl-1.1.19.tar.gz | \
    tar xzf - && \
    cd musl-1.1.19 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/musl-x86_64 && \
    make install -j4 && \
    cd .. && \
    rm -rf musl-1.1.19
# Install linux kernel headers sanitized for use with musl
RUN curl -f -L https://github.com/sabotage-linux/kernel-headers/archive/v3.12.6-6.tar.gz | \
    tar xzf - && \
    cd kernel-headers-3.12.6-6 && \
    make ARCH=x86_64 prefix=/musl-x86_64 install -j4 && \
    cd .. && \
    rm -rf kernel-headers-3.12.6-6
ENV PATH=$PATH:/musl-x86_64/bin:/rust/bin
