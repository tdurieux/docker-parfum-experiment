FROM debian:bullseye as build
# Ping with HTTP requests, see http://www.vanheusden.com/httping/
# built directly from master

LABEL maintainer="Bret Fisher <bret@bretfisher.com>"

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        make \
        cmake \
        gettext \
        git \
        libncurses-dev \
        libncursesw-dev \
        libssl-dev \
        libfftw3-dev \
        libfftw3-bin \
        libfftw3-double3 \
        libgomp1 \
        libssl1.1 \
        openssl \
        apt-transport-https \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /source

COPY source .

RUN make

# to prevent image bloat, lets do a multi-stage build and only copy the binary needed
FROM debian:bullseye-slim as release

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libfftw3-bin \
        libfftw3-dev \
        libfftw3-double3 \
        libgomp1 \
        libssl1.1 \
        libncurses-dev \
        openssl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /source/httping /usr/local/bin/

ENV TERM=xterm-256color

# add -Y for nice color output!
ENTRYPOINT ["httping", "-Y"]

CMD ["--version"]