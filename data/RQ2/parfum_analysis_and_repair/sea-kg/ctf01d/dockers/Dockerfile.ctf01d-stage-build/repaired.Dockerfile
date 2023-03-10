FROM debian:10
# stage build
LABEL "maintainer"="Evgenii Sopov <mrseakg@gmail.com>"
LABEL "repository"="https://github.com/sea-kg/ctf01d"

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y \
    make cmake \
    g++ \
    pkg-config \
    libcurl4-openssl-dev \
    zlibc zlib1g zlib1g-dev \
    libpng-dev \
    default-libmysqlclient-dev \
    python \
    python-pip \
    python3 \
    python3-pip \
    && pip install --no-cache-dir requests \
    && pip3 install --no-cache-dir requests && rm -rf /var/lib/apt/lists/*;

# Old Fix for building on debian system (mysqlclient library)
# RUN ln -s /usr/lib/x86_64-linux-gnu/pkgconfig/mariadb.pc /usr/lib/x86_64-linux-gnu/pkgconfig/mysqlclient.pc