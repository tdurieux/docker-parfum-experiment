FROM debian:jessie AS builder

RUN apt-get update && apt-get install --no-install-recommends -y curl build-essential libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

# Install rust
RUN curl https://sh.rustup.rs/ -sSf | \
  sh -s -- -y --default-toolchain nightly-2019-10-29

ENV PATH="/root/.cargo/bin:${PATH}"

ADD . ./

RUN cargo build --release

FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder \
  /target/release/rssfilter \
  /usr/local/bin/

WORKDIR /root
CMD ROCKET_PORT=$PORT /usr/local/bin/rssfilter
