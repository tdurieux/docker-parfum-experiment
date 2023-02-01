# Use multi-stage build to reduce image size
FROM quay.io/stegos/rust:nightly-2019-11-25 AS source
LABEL maintainer="Stegos AG <info@stegos.com>"

### The next few lines is hack that speeedup rebuilding by preventing rebuild dependencies
#### START CARGO HACK THAT PREVENT REBUILD 
WORKDIR /usr/src/
# create a new empty  project
RUN USER=root cargo new --lib stegos
WORKDIR /usr/src/stegos

COPY ./api/Cargo.toml ./api/Cargo.toml
COPY ./blockchain/Cargo.toml ./blockchain/Cargo.toml
COPY ./consensus/Cargo.toml ./consensus/Cargo.toml
COPY ./crypto/Cargo.toml ./crypto/Cargo.toml
COPY ./keychain/Cargo.toml ./keychain/Cargo.toml
COPY ./network/Cargo.toml ./network/Cargo.toml
COPY ./node/Cargo.toml ./node/Cargo.toml
COPY ./txpool/Cargo.toml ./txpool/Cargo.toml
COPY ./replication/Cargo.toml ./replication/Cargo.toml
COPY ./serialization/Cargo.toml ./serialization/Cargo.toml
COPY ./wallet/Cargo.toml ./wallet/Cargo.toml
COPY ./stegos_lib_test/Cargo.toml ./stegos_lib_test/Cargo.toml
COPY ./3rdparty/gossipsub/Cargo.toml ./3rdparty/gossipsub/Cargo.toml


COPY ./crypto/stubs/vdf_field/Cargo.toml ./crypto/stubs/vdf_field/Cargo.toml
# Add stub libs and bins
COPY ./ci-scripts/docker-cargo-hack.sh ./ci-scripts/docker-cargo-hack.sh
RUN ./ci-scripts/docker-cargo-hack.sh
# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release --bins

# Backup target with dependencies
WORKDIR /usr/src/
RUN mv stegos/target /backup
RUN rm -r stegos
RUN mkdir stegos
RUN mv /backup stegos/target
WORKDIR /usr/src/stegos

# Remove leaf stub builds from dependencies
RUN rm ./target/release/deps/stegos*
RUN rm ./target/release/deps/libstegos*
RUN rm ./target/release/deps/libp2p_gossipsub*
RUN rm ./target/release/deps/liblibp2p_gossipsub*

RUN rm -r ./target/release/build/stegos*
RUN rm -r ./target/release/build/libp2p-gossipsub*
#### END CARGO HACK