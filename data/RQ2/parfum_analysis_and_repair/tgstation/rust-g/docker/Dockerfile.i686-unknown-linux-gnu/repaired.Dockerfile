FROM rustembedded/cross:i686-unknown-linux-gnu

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y --no-install-recommends --assume-yes zlib1g-dev:i386 libssl-dev:i386 pkg-config:i386 && rm -rf /var/lib/apt/lists/*;
