FROM ubuntu:jammy

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends install -y \
    tzdata \
    wget \
    sudo \
    libmemcached-dev \

    libfreetype-dev && rm -rf /var/lib/apt/lists/*;

# Retrieve seafile build script
RUN wget https://raw.githubusercontent.com/haiwen/seafile-rpi/master/build.sh
RUN chmod u+x build.sh

# Install build dependencies
RUN ./build.sh -D