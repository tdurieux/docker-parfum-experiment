# we build with go and rust
FROM golang:1.14-alpine3.12

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# this comes from standard alpine nightly file
#  https://github.com/rust-lang/docker-rust-nightly/blob/master/alpine3.12/Dockerfile
# with some changes to support our toolchain, etc
RUN set -eux; \
    apk add --no-cache \
    ca-certificates \
    build-base;

RUN wget "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-musl/rustup-init"
RUN chmod +x rustup-init
RUN ./rustup-init -y --no-modify-path --default-toolchain nightly-2020-06-08; rm rustup-init
RUN chmod -R a+w $RUSTUP_HOME $CARGO_HOME

# needed for
# /usr/lib/gcc/x86_64-alpine-linux-musl/9.3.0/../../../../x86_64-alpine-linux-musl/bin/ld: cannot find crti.o: No such file or directory
ENV LIBRARY_PATH=/usr/local/rustup/toolchains/nightly-2020-06-08-x86_64-unknown-linux-musl/lib/rustlib/x86_64-unknown-linux-musl/lib:$LIBRARY_PATH

# prepare go cache dirs
RUN mkdir -p /.cache/go-build
RUN chmod -R 777 /.cache


# PRE-FETCH MANY DEPS
WORKDIR /scratch
COPY Cargo.toml /scratch/
COPY Cargo.lock /scratch/
COPY src /scratch/src
RUN cargo fetch
# allow non-root user to download more deps later
RUN chmod -R 777 /usr/local/cargo

## COPY BUILD SCRIPTS