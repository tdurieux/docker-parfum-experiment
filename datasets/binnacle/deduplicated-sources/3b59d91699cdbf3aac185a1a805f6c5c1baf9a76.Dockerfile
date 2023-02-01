FROM phusion/baseimage:0.11 AS builder
LABEL maintainer="jake@commonwealth.im"
LABEL description="This is the build stage. Here we create the binary."

RUN install_clean build-essential \
    pkg-config \
    clang \
    libssl-dev \
    openssl \
    cmake \
    git \
    curl

ARG PROFILE=release
WORKDIR /edgeware

COPY . /edgeware

# Update rust dependencies
ENV RUSTUP_HOME "/edgeware/.rustup"
ENV CARGO_HOME "/edgeware/.cargo"
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH "$PATH:/edgeware/.cargo/bin"
RUN rustup update nightly
RUN RUSTUP_TOOLCHAIN=stable cargo install --git https://github.com/alexcrichton/wasm-gc

# Build runtime and binary
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cd /edgeware/node/runtime/wasm && ./build.sh
RUN cd /edgeware && RUSTUP_TOOLCHAIN=stable cargo build --$PROFILE

# ===== SECOND STAGE ======

FROM phusion/baseimage:0.11
LABEL maintainer="hello@commonwealth.im"
LABEL description="This is the 2nd stage: a very small image where we copy the Edgeware binary."
ARG PROFILE=release
COPY --from=builder /edgeware/target/$PROFILE/edgeware /usr/local/bin
COPY --from=builder /edgeware/testnets /usr/local/bin/testnets

RUN rm -rf /usr/lib/python* && \
	mkdir -p /root/.local/share && \
	ln -s /root/.local/share /data

EXPOSE 30333 9933 9944
VOLUME ["/data"]

WORKDIR /usr/local/bin
CMD ["edgeware", "--chain", "edgeware", "--ws-external"]
