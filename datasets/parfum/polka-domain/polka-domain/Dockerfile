# Note: We don't use Alpine and its packaged Rust/Cargo because they're too often out of date,
# preventing them from being used to build Substrate/Polkadot.

FROM phusion/baseimage:0.11 as builder
LABEL maintainer=""
LABEL description="This is the build stage for polka-domain Here we create the binary."

ENV DEBIAN_FRONTEND=noninteractive

ARG PROFILE=release
WORKDIR /polka-domain

COPY . /polka-domain

RUN apt-get update && \
	apt-get dist-upgrade -y -o Dpkg::Options::="--force-confold" && \
	apt-get install -y cmake pkg-config libssl-dev git clang

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
	export PATH="$PATH:$HOME/.cargo/bin" && \
	rustup toolchain install nightly && \
	rustup target add wasm32-unknown-unknown --toolchain nightly && \
	rustup default stable && \
	cargo build "--$PROFILE"

# ===== SECOND STAGE ======

FROM phusion/baseimage:0.11
LABEL maintainer=""
LABEL description="This is the 2nd stage: a very small image where we copy the polka-domain binary."
ARG PROFILE=release

RUN mv /usr/share/ca* /tmp && \
	rm -rf /usr/share/*  && \
	mv /tmp/ca-certificates /usr/share/ && \
	useradd -m -u 1000 -U -s /bin/sh -d /polka-domain polka-domain && \
	mkdir -p /polka-domain/.local/share/polka-domain-collator && \
	chown -R polka-domain:polka-domain /polka-domain/.local && \
	ln -s /polka-domain/.local/share/polka-domain-collator /data

COPY --from=builder /polka-domain/target/$PROFILE/polka-domain-collator /usr/local/bin

# checks
RUN ldd /usr/local/bin/polka-domain-collator && \
	/usr/local/bin/polka-domain-collator --version

# Shrinking
RUN rm -rf /usr/lib/python* && \
	rm -rf /usr/bin /usr/sbin /usr/share/man

USER polka-domain
EXPOSE 30333 9933 9944 9615
VOLUME ["/data"]

CMD ["/usr/local/bin/polka-domain-collator"]