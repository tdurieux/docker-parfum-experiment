#Not a big fan of using nightly, but such is our lot currently
FROM rust:latest as builder

RUN rustup component add rustfmt
RUN apt-get update && apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/trow

#First get just the deps
COPY Cargo.toml .
COPY Cargo.lock .

RUN mkdir src/
RUN echo "fn main() {}" > src/main.rs

# trow-server
COPY trow-server/Cargo.toml trow-server/
RUN mkdir -p trow-server/src
RUN touch trow-server/src/lib.rs

# trow-protobuf
COPY trow-protobuf/Cargo.toml trow-protobuf/
RUN echo "fn main() {}" > trow-protobuf/build.rs
RUN mkdir -p trow-protobuf/src
RUN touch trow-protobuf/src/lib.rs

RUN cargo test --workspace --no-run


COPY src src
COPY trow-server trow-server
COPY trow-protobuf trow-protobuf
COPY tests tests

RUN mkdir certs
COPY quick-install/self-cert/make-certs.sh certs/
COPY quick-install/self-cert/in.req certs/
RUN cd certs && ./make-certs.sh

RUN cargo test --workspace
