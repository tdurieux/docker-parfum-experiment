FROM rustlang/rust:nightly-buster AS build

WORKDIR /app

COPY . /app

RUN rustup --version
RUN rustup install nightly-2021-01-07 && \
    rustup default nightly-2021-01-07

RUN rustc --version && \
    rustup --version && \
    cargo --version

RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl-dev default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

RUN cargo clean && cargo build --release
RUN strip ./target/release/raider

FROM debian:buster-slim

RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.1 libmariadb3 && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/raider

COPY ./res/assets/ ./res/assets/
COPY --from=build /app/target/release/raider /usr/local/bin/raider

CMD [ "raider", "-c", "/etc/raider.cfg" ]

EXPOSE 8080
