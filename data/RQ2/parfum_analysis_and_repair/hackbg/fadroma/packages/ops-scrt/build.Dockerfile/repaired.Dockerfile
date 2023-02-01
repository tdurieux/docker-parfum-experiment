# was "FROM rust:1.46" for 1.0
FROM rust:1.57
ENV REGISTRY /usr/local/cargo/registry
ENV USER 1000
ENV GROUP 1000

RUN rustup target add wasm32-unknown-unknown
RUN apt update && apt install --no-install-recommends -y binaryen sudo git clang nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN npm i -g n && n i 18 && npm cache clean --force;
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p "$REGISTRY"
WORKDIR /src

ADD ./build-impl.mjs ./build-server.mjs /
CMD node /build-impl.mjs
