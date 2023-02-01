##############################################################################################################
FROM krakenci/chp-builder as builder

# copy your source tree
COPY ./src ./src
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# build for release
RUN rm ./target/release/deps/clickhouse_proxy*
RUN cargo build --release

##############################################################################################################