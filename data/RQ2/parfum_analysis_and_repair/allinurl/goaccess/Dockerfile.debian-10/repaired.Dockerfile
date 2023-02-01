# Used to have all compile dependencies isolated in a container image.
FROM debian:10

RUN apt-get update -qqq && apt-get install --no-install-recommends -yqqq \
    autoconf \
    build-essential \
    clang \
    gettext \
    libmaxminddb-dev \
    libssl-dev \
    linux-headers-amd64 \
    libncursesw5-dev \
    libgeoip-dev \
    pkg-config \
    autopoint && rm -rf /var/lib/apt/lists/*;

# GoAccess
WORKDIR /goaccess

ENTRYPOINT ["./build-dynamic.sh"]

