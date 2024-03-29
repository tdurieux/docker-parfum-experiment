FROM debian:11-slim as build
MAINTAINER Nitrokey <info@nitrokey.com>

RUN apt-get update  \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    bzip2 \
  && rm -rf /var/lib/apt/lists/*

ENV URL https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
ENV MD5 2383e4eb4ea23f248d33adc70dc3227e
ENV FILENAME gcc-arm-11.2-2022.02-x86_64-arm-none-eabi.tar.xz

RUN set -eux; \
	wget -O gcc.tar.bz2 "${URL}" && \
    echo "${MD5} gcc.tar.bz2" | md5sum -c -&& \
	tar -C /opt -xf gcc.tar.bz2&& \
	rm gcc.tar.bz2;

FROM debian:11-slim as target
COPY --from=build /opt /opt/
RUN apt-get update  \
  && apt-get install -y --no-install-recommends \
    make \
    git \
  && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/gcc-arm-none-eabi-10.3-2021.10/bin/:$PATH
RUN arm-none-eabi-gcc --version