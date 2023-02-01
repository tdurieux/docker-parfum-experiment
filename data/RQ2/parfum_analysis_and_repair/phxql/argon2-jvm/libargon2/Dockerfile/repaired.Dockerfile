FROM ubuntu:16.04
# Install needed tools to build (I'm unable to put gcc-arm-linux-gnueabihf with the other stuff in apt install, wtf apt?!)
RUN apt update && apt install --no-install-recommends --yes wget make binutils gcc gcc-multilib && apt install --no-install-recommends --yes gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu && apt clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /
ADD build-libargon2.sh .
CMD /build-libargon2.sh
