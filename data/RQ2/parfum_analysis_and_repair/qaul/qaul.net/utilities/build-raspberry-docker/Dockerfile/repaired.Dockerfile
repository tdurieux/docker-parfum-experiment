FROM rust:latest
WORKDIR /qaul
# install target for rasperry
RUN rustup target add armv7-unknown-linux-gnueabihf
# install linker for target
RUN apt update && apt install --no-install-recommends -y gcc-arm-linux-gnueabihf && rm -rf /var/lib/apt/lists/*;
# create user with ID 1000:1000
#RUN useradd -m docker --uid=1000
USER 1000:1000
# build qaul.net on every startup of the docker
# container
CMD ["cargo","build","--target=armv7-unknown-linux-gnueabihf"]
#CMD ["cargo","build","--release","--target=armv7-unknown-linux-gnueabihf"]
