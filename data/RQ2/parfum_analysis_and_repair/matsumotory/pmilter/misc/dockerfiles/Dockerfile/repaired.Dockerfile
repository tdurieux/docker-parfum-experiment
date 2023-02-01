FROM ubuntu:xenial

RUN apt -y update && apt -y --no-install-recommends install \
    build-essential automake m4 autoconf ragel \
    libtool cmake pkg-config libcunit1-dev libicu-dev \
    ruby bison && rm -rf /var/lib/apt/lists/*;

VOLUME /pmilter

WORKDIR /pmilter

CMD ["/usr/bin/make"]
