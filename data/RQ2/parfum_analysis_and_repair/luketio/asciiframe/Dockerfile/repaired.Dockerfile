FROM rust:1.58 as build

# create a new empty shell project
RUN USER=root cargo new --bin asc
WORKDIR /asciiframe

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN apt-get -y update && apt-get install --no-install-recommends -y libclang-dev libopencv-dev && rm -rf /var/lib/apt/lists/*;
RUN cargo build --release --locked
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/asc*
RUN cargo build --release --locked

# our final base
FROM rust:1.58

# copy the build artifact from the build stage
COPY --from=build /asciiframe/target/release/asc .

# set the startup command to run your binary
ENTRYPOINT ["./asc"]
