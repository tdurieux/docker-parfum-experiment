From debian:buster-slim

Run dpkg --add-architecture i386
Run apt-get update && apt-get install --no-install-recommends -y libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g-dev:i386 && rm -rf /var/lib/apt/lists/*;
