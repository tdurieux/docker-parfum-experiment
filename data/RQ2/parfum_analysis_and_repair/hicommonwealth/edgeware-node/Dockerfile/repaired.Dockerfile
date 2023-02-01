#FROM paritytech/ci-linux:production as builder
FROM decentration/edgeware:v3.3.3 as builder

LABEL description="This is the build stage for edgeware. Here we create the binary."

ARG PROFILE=release
WORKDIR /edgeware

COPY . /edgeware/
#RUN  fallocate -l 1G /swapfile
RUN rustup uninstall nightly
RUN rustup install nightly-2021-05-31
RUN rustup update nightly
RUN rustup target add wasm32-unknown-unknown --toolchain nightly-2021-05-31


RUN cargo build --$PROFILE -j 1

# ===== SECOND STAGE ======