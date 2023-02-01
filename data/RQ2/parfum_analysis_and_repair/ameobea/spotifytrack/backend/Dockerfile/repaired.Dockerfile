FROM debian:stable AS builder

RUN apt-get update && apt-get install --no-install-recommends -y curl libmariadbclient-dev-compat build-essential libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates

# Install rust
RUN curl https://sh.rustup.rs/ -sSf | \
  sh -s -- -y --default-toolchain nightly-2021-10-05

ENV PATH="/root/.cargo/bin:${PATH}"

ADD . ./

RUN cargo build --release

FROM debian:stable

RUN apt-get update && apt-get install --no-install-recommends -y libmariadbclient-dev-compat && rm -rf /var/lib/apt/lists/*;

COPY --from=builder \
  /target/release/spotify-homepage-backend \
  /usr/local/bin/

RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev ca-certificates && update-ca-certificates && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN touch .env
CMD ROCKET_PORT=$PORT /usr/local/bin/spotify-homepage-backend
