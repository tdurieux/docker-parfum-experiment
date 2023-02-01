FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl xz-utils python3 python3-pip gcc make libnuma-dev numactl && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir meson pyelftools ninja

ADD patches/* /tmp/dpdk/patches/

RUN curl -f https://fast.dpdk.org/rel/dpdk-21.02.tar.xz -o /tmp/dpdk/dpdk-21.02.tar.xz && \
  cd /tmp/dpdk && \
  tar -xvf dpdk-21.02.tar.xz && \
  cd /tmp/dpdk/dpdk-21.02 && \
  patch -p1 < /tmp/dpdk/patches/0000-memif-abstract-fix.patch && \
  cd /tmp/dpdk/dpdk-21.02 && \
  meson build && ninja -C build && \
  cp ./build/app/dpdk-testpmd /usr/local/bin/testpmd && \
  rm -rf /tmp/dpdk && rm dpdk-21.02.tar.xz

ADD memif-testpmd.sh /usr/bin/memif-testpmd
RUN chmod +x /usr/bin/memif-testpmd

ENTRYPOINT ["tail", "-f", "/dev/null"]
