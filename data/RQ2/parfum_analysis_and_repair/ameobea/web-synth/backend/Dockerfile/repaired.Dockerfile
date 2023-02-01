FROM debian:jessie AS builder

RUN apt-get update && apt-get install --no-install-recommends -y curl libmysqlclient-dev build-essential pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;

# Install rust
RUN curl https://sh.rustup.rs/ -sSf | \
  sh -s -- -y --default-toolchain nightly-2021-11-26

ENV PATH="/root/.cargo/bin:${PATH}"

ADD . ./

RUN cargo build --release

FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y libmysqlclient-dev libssl-dev ca-certificates && update-ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY --from=builder \
  /target/release/web-synth-backend \
  /usr/local/bin/
COPY --from=builder \
  /Rocket.toml \
  /root/Rocket.toml
WORKDIR /root
CMD ROCKET_PORT=$PORT /usr/local/bin/web-synth-backend
