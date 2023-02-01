FROM rustembedded/cross:x86_64-unknown-linux-gnu-0.2.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes libudev-dev && rm -rf /var/lib/apt/lists/*;

RUN pkg-config --list-all && pkg-config --libs libudev && \
    pkg-config --modversion libudev