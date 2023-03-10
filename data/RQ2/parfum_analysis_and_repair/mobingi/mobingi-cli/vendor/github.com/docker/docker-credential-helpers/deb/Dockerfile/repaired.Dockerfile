FROM ubuntu:xenial

ARG VERSION
ARG DISTRO

RUN apt-get update && apt-get install --no-install-recommends -yy debhelper dh-make golang-go libsecret-1-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /build

WORKDIR /build
ENV GOPATH /build

COPY Makefile .
COPY credentials credentials
COPY secretservice secretservice
COPY pass pass
COPY deb/debian ./debian
COPY deb/build-deb .

RUN /build/build-deb ${VERSION} ${DISTRO}
