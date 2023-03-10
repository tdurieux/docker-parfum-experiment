FROM ghcr.io/hyperledger/aries-vcx/libvcx:0.26.0-main-2610

USER root

ENV X86_64_UNKNOWN_LINUX_MUSL_OPENSSL_NO_VENDOR true
RUN rustup default stable

WORKDIR /
RUN cargo new --bin aries-vcx-backchannel
WORKDIR ./aries-vcx-backchannel
COPY ./aries-vcx/Cargo.lock ./aries-vcx/Cargo.toml ./
RUN cargo build
RUN rm src/*.rs
RUN rm ./target/debug/deps/aries_vcx_backchannel*
COPY ./aries-vcx/src ./src
COPY ./aries-vcx/resource ./resource
RUN cargo build

ENTRYPOINT ["./target/debug/aries-vcx-backchannel"]