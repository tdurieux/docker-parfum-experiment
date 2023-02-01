FROM ubuntu:20.04 as base
ENV DEBIAN_FRONTEND=noninteractive

ENV PROJECT=udp-proxy-2020

RUN apt-get update && apt-get install --no-install-recommends -y golang-1.16-go libpcap0.8 libpcap0.8-dev make git && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /build

FROM base
WORKDIR /build
COPY . /build/$PROJECT/

WORKDIR /build/$PROJECT
ENV GOROOT=/usr/lib/go-1.16
ENV PATH=/build/bin:${GOROOT}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT make .linux-amd64
