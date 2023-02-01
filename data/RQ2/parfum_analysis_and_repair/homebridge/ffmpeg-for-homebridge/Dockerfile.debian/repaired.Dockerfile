ARG BASE_IMAGE
FROM ${BASE_IMAGE:-balenalib/raspberry-pi-debian:stretch}

COPY qemu /usr/bin/

RUN apt-get update && apt-get install --no-install-recommends -y build-essential curl g++ autoconf && rm -rf /var/lib/apt/lists/*;

COPY build-ffmpeg /

ENV SKIPINSTALL=yes VERBOSE=yes

VOLUME /build
WORKDIR /build

CMD /build-ffmpeg --build