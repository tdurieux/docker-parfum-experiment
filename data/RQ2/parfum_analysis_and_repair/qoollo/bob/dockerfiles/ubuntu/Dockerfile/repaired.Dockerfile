# build image
FROM rust:1.47.0 as cargo-build

# rust toolchain version
ARG RUST_TC_VER=stable
ARG KEY_SIZE=8
ARG COMMIT_HASH

RUN rustup install $RUST_TC_VER \
  && rustup default $RUST_TC_VER \
  && rustup target add x86_64-unknown-linux-gnu

WORKDIR /usr/src/bob

# crates downloading and initial build
RUN mkdir -p bob/src bob-backend/src bob-common/src bob-grpc/src bob-apps/bin bob-access/src
RUN mkdir target
ENV OUT_DIR /usr/src/bob/target
COPY Cargo.toml Cargo.toml
COPY bob/Cargo.toml bob/Cargo.toml
COPY bob-backend/Cargo.toml bob-backend/Cargo.toml
COPY bob-common/Cargo.toml bob-common/Cargo.toml
COPY bob-grpc/Cargo.toml bob-grpc/Cargo.toml
COPY bob-apps/Cargo.toml bob-apps/Cargo.toml
COPY bob-access/Cargo.toml bob-access/Cargo.toml
RUN sed -i "s|\[\[bench\]\]|\[\[bench_ignore\]\]|g" */Cargo.toml

RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > bob/src/lib.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-backend/src/lib.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-common/src/lib.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-grpc/src/lib.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-apps/bin/bobd.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-apps/bin/bobc.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-apps/bin/bobp.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-apps/bin/ccg.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-apps/bin/dcr.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-apps/bin/brt.rs \
  && echo "fn main() {println!(\"if you see this, the build broke\")}" > bob-access/src/lib.rs \
  && cargo build --release --target=x86_64-unknown-linux-gnu


# separate stage for proto build
RUN echo "fn main() {println!(\"if you see this, the build broke\")} pub mod grpc {include!(\"bob_storage.rs\");}" > bob-grpc/src/lib.rs \
  && mkdir -p bob-grpc/proto
COPY bob-grpc/proto/* bob-grpc/proto/
COPY bob-grpc/build.rs bob-grpc/build.rs
RUN cargo build --release --target=x86_64-unknown-linux-gnu \
  && rm -f target/x86_64-unknown-linux-gnu/release/deps/bob* \
  && rm -f target/x86_64-unknown-linux-gnu/release/deps/libbob*

# final build
COPY . .
ENV BOB_KEY_SIZE=${KEY_SIZE}
ENV BOB_COMMIT_HASH=${COMMIT_HASH}
RUN cargo build --release --target=x86_64-unknown-linux-gnu

# bobd image
FROM ubuntu:20.04

# SSH