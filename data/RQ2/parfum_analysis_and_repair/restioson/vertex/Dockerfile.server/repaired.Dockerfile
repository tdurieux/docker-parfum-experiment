FROM rustlang/rust:nightly-slim as build

WORKDIR /vertex/server
COPY server/Cargo.* .

# Build deps except for vertex_common
RUN mkdir src/ && rustc --version && echo "fn main() {}" > src/main.rs \
    && sed -i 's/vertex = /#vertex = /g' Cargo.toml && cargo +nightly  build --release

# Build vertex_common
COPY common/ ../common/
RUN sed -i 's/#vertex = /vertex = /g' Cargo.toml && cargo +nightly  build --release && rm src/main.rs

# Build project
COPY server/src src
RUN touch src/main.rs && cargo +nightly build --release

# Run
FROM debian:stretch

RUN echo "Installing psql" && apt-get update > /dev/null && apt-get install --no-install-recommends postgresql-client -y > /dev/null && \
    rm -r /var/lib/apt/lists/* && echo "psql installed"
COPY --from=build /vertex/server/target/release/vertex_server ./vertex_server

# Copy config files
COPY server/docker/config.toml server/docker/key.pe[m] server/docker/cert.pe[m] /root/.config/vertex_server/
COPY server/docker/db.conf /root/.config/vertex_server/

ARG VERTEX_SERVER_PORT
ENV VERTEX_SERVER_PORT=$VERTEX_SERVER_PORT

COPY wait-for-postgres.sh .
EXPOSE 443
CMD ["/bin/sh", "wait-for-postgres.sh", "db", "5342"]
