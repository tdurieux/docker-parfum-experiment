FROM debian:latest as rustenv

ARG IS_LOCAL=0
ARG VERSION=main
ARG IS_TAG=0

COPY . /code
WORKDIR /code
RUN apt-get update -qq && apt-get install --no-install-recommends curl pkg-config build-essential libssl-dev ca-certificates -y && apt-get autoclean -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL sh.rustup.rs >/usr/local/bin/rustup-dl && chmod +x /usr/local/bin/rustup-dl && /usr/local/bin/rustup-dl -y --default-toolchain stable

FROM rustenv as buildenv

RUN sh cargo-docker.sh

FROM debian:latest
RUN apt-get update -qq && apt-get install --no-install-recommends ca-certificates -y && apt-get autoclean -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*;
COPY --from=buildenv /root/.cargo/bin/zeronsd /usr/bin/zeronsd

ENTRYPOINT ["/usr/bin/zeronsd"]
