FROM rustembedded/cross:powerpc64le-unknown-linux-gnu-0.2.1

RUN dpkg --add-architecture powerpc64le && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes libudev-dev && rm -rf /var/lib/apt/lists/*;

RUN pkg-config --list-all && pkg-config --libs libudev && \
    pkg-config --modversion libudev