ARG OS_TAG=18.04
FROM ubuntu:${OS_TAG} as builder

ARG OS_TAG
ARG BUILD_TYPE=release
ARG DEBIAN_FRONTEND=noninteractive

MAINTAINER Brenden Blanco <bblanco@gmail.com>

RUN apt-get -qq update && \
    apt-get -y --no-install-recommends install pbuilder aptitude && rm -rf /var/lib/apt/lists/*;

COPY ./ /root/bcc

WORKDIR /root/bcc

RUN /usr/lib/pbuilder/pbuilder-satisfydepends && \
    ./scripts/build-deb.sh ${BUILD_TYPE}

FROM ubuntu:${OS_TAG}

COPY --from=builder /root/bcc/*.deb /root/bcc/

RUN \
  apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y python python3 python3-pip binutils libelf1 kmod && \
  if [ ${OS_TAG} = "18.04" ]; then \
    apt-get -y --no-install-recommends install python-pip && \
    pip install --no-cache-dir dnslib cachetools; \
  fi; rm -rf /var/lib/apt/lists/*; \
  pip3 install --no-cache-dir dnslib cachetools && \
  dpkg -i /root/bcc/*.deb
