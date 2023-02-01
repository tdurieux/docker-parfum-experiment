FROM rust:1.37.0-buster

RUN rustup install nightly
RUN rustup default nightly

RUN apt-get update \
  && apt-get install --no-install-recommends -y git libgtk-3-dev && rm -rf /var/lib/apt/lists/*;

# for wasm
RUN apt-get install --no-install-recommends -y nodejs npm gcc g++ gcc-arm-none-eabi && rm -rf /var/lib/apt/lists/*;
RUN npm install -g n && npm cache clean --force;
RUN n 10.15.1
RUN cargo install wasm-pack
RUN rustup target add thumbv6m-none-eabi thumbv7m-none-eabi thumbv7em-none-eabi thumbv7em-none-eabihf
RUN rustup run nightly rustup target add thumbv6m-none-eabi thumbv7m-none-eabi thumbv7em-none-eabi thumbv7em-none-eabihf

RUN mkdir /work
WORKDIR /work

CMD ["/bin/sh"]