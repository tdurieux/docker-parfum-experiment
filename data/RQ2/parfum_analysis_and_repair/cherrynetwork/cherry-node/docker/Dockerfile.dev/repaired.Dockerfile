FROM phusion/baseimage:0.11 as builder
LABEL maintainer="liompis@cherrylabs.org"
LABEL description="This is the build stage for Cherry Chain. Here we create the binary."

ENV DEBIAN_FRONTEND=noninteractive

ARG PROFILE=release
WORKDIR /substrate

COPY . /substrate

RUN apt-get update && \
	apt-get dist-upgrade -y -o Dpkg::Options::="--force-confold" && \
	apt-get install --no-install-recommends -y cmake pkg-config libssl-dev git clang && rm -rf /var/lib/apt/lists/*;

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
	export PATH="$PATH:$HOME/.cargo/bin" && \
	rustup toolchain install nightly && \
	rustup target add wasm32-unknown-unknown --toolchain nightly && \
	rustup default stable && \
	cargo build "--$PROFILE" --features dev

# ===== SECOND STAGE ======

FROM phusion/baseimage:0.11
LABEL maintainer="liompis@cherrylabs.org"
LABEL description="This is the 2nd stage: a very small image where we copy the Cherry binary."
ARG PROFILE=release

RUN mv /usr/share/ca* /tmp && \
	rm -rf /usr/share/*  && \
	mv /tmp/ca-certificates /usr/share/ && \
	useradd -m -u 1000 -U -s /bin/sh -d /substrate substrate && \
	mkdir -p /substrate/.local/share/substrate && \
	chown -R substrate:substrate /substrate/.local && \
	ln -s /substrate/.local/share/substrate /data

COPY --from=builder /substrate/target/$PROFILE/cherry /usr/local/bin
COPY --from=builder /substrate/target/$PROFILE/subkey /usr/local/bin
COPY --from=builder /substrate/target/$PROFILE/node-rpc-client /usr/local/bin
COPY --from=builder /substrate/target/$PROFILE/chain-spec-builder /usr/local/bin

# checks
RUN ldd /usr/local/bin/cherry && \
	/usr/local/bin/cherry --version

# Shrinking
RUN rm -rf /usr/lib/python* && \
	rm -rf /usr/bin /usr/sbin /usr/share/man

USER substrate
EXPOSE 30333 9933 9944 9615
VOLUME ["/data"]

CMD ["/usr/local/bin/cherry"]
