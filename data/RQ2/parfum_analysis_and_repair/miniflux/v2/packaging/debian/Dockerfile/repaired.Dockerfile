ARG BASE_IMAGE_ARCH="amd64"

FROM ${BASE_IMAGE_ARCH}/golang:buster AS build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && \
    apt-get install --no-install-recommends -y -qq build-essential devscripts dh-make dh-systemd && \
    mkdir -p /build/debian && rm -rf /var/lib/apt/lists/*;

ADD . /src

CMD ["/src/packaging/debian/build.sh"]
