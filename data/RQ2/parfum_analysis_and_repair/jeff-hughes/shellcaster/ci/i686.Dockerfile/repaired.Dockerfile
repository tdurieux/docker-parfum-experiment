FROM rustembedded/cross:i686-unknown-linux-gnu

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes libncurses5-dev:i386 libncursesw5-dev:i386 libsqlite3-dev:i386 && rm -rf /var/lib/apt/lists/*;
