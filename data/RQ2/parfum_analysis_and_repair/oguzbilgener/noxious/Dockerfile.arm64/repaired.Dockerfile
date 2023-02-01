# Because docker arm builds on QEMU on GitHub actions is super slow (30+ minutes slow),
# We cross-compile noxious for arm64 on amd64, then add the final binary in a arm64 image
FROM --platform=linux/amd64 rust:latest as serverbuild

ARG TARGET="aarch64-unknown-linux-gnu"

RUN rustup target install $TARGET

RUN apt-get update && apt-get install --no-install-recommends -y gcc-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src

WORKDIR /usr/src
COPY . ./

RUN cargo build \
    --release \
    --target $TARGET \
    --package noxious-server

FROM debian:buster-slim as server
ARG TARGET="aarch64-unknown-linux-gnu"
WORKDIR /app
COPY --from=serverbuild /usr/src/target/$TARGET/release/noxious-server ./noxious-server

EXPOSE 8474

ENTRYPOINT ["./noxious-server"]
CMD ["--host=0.0.0.0"]
