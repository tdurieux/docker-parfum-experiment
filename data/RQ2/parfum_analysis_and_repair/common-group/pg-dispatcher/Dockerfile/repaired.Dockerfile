FROM rust:1.20-jessie as build-env

WORKDIR /usr/app
COPY . .

RUN cargo build --release
RUN cp -rf ./target/release/pg-dispatcher /usr/local/bin/

FROM debian:jessie
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=build-env /usr/app/target/release/pg-dispatcher /usr/local/bin/
