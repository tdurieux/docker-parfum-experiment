FROM debian:latest
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install --no-install-recommends \
      libc6-i386 \
      tcpd \
      xinetd \
      python3 \
      python3-setuptools \
      python3-cryptography \
      python3-pip && \
  apt clean && \
  pip3 install wheel && \
  pip3 install timeout-decorator
ENTRYPOINT [ "xinetd", "-dontfork" ]
RUN useradd -s /bin/bash -d / -u 1337 user && \
useradd -s /bin/bash -d / -u 1338 admin

RUN ln -snf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
