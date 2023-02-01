# build stage
FROM rust as build

# create a new empty shell project
RUN USER=root cargo new --bin medusa
WORKDIR /medusa

# copy contents and cache dependencies
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release
RUN rm src/*.rs
COPY ./src ./src

# build