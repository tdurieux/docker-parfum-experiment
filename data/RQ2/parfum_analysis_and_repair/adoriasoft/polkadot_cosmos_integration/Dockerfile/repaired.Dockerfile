FROM phusion/baseimage:0.10.2 as builder

ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade && \
	apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade && \
	apt-get install --no-install-recommends -y cmake pkg-config libssl-dev git clang && rm -rf /var/lib/apt/lists/*;
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH

WORKDIR /substrate

RUN rustup +nightly-2020-08-19 target add wasm32-unknown-unknown
ARG PROJECT=node-template
ARG PROFILE=release

COPY . .

RUN cargo +nightly-2020-08-19 build --$PROFILE && \
	mv ./target/$PROFILE/$PROJECT /app

FROM phusion/baseimage:0.10.2
LABEL org.opencontainers.image.source https://github.com/adoriasoft/polkadot_cosmos_integration
COPY --from=builder /app .
ENTRYPOINT ["/app"]
