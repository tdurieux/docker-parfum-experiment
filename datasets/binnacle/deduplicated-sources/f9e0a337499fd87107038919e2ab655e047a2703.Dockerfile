FROM debian:testing
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq reprotest \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq git curl libsodium-dev libseccomp-dev libzmq3-dev
ENV PYTHONIOENCODING=utf-8
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly \
    && cp ~/.cargo/bin/rustup ~/.cargo/bin/cargo ~/.cargo/bin/rustc /usr/bin/
WORKDIR /tr1pd/
COPY . .
