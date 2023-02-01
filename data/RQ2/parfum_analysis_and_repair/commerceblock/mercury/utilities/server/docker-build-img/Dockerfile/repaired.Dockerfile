FROM ubuntu:xenial
LABEL maintainer="g.benattar@gmail.com"
LABEL description="This is the build stage for Gotham server"

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    make \
    g++ \
    curl \
    clang \
    libgmp3-dev \
    libssl-dev \
    pkg-config \
    npm && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD . /

WORKDIR /utilities/server/cognito
RUN ["npm", "install"]

# Rust
ARG CHANNEL="nightly"
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly-2019-07-10

ENV rocket_address=0.0.0.0
ENV rocket_port=8000

EXPOSE 8000
WORKDIR /server
RUN ["/root/.cargo/bin/cargo", "build", "--release"]


WORKDIR /integration-tests
RUN ["/root/.cargo/bin/cargo", "test", "--release", "--", "--nocapture"]

# Server
ENV db=AWS
WORKDIR /server
CMD ["/root/.cargo/bin/cargo", "run", "--release"]
