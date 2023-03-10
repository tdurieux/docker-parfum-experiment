FROM rust:1.62.0 AS chef
# We only pay the installation cost once,
# it will be cached from the second build onwards
RUN cargo install cargo-chef
WORKDIR /navigatum-server

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS build
COPY --from=planner /navigatum-server/recipe.json recipe.json

# Build dependencies - this is the caching Docker layer!
RUN cargo chef cook --release --recipe-path recipe.json

# Build navigatum-server
COPY src ./src

# get api_data.json
ADD https://nav.tum.sexy/cdn/api_data.json data/api_data.json
# For local testing if roomapi is not avalible:
# follow the data-docs to get api_data.json, copy it to the directory server/data and enable
# COPY data/api_data.json data/api_data.json

EXPOSE 8080
HEALTHCHECK CMD [ curl -f localhost:8080/api/health]
CMD tail -f /dev/null
#CMD cargo run --release

# WHY does the above work, while the below does not???
# libm.so.6 is not availible but
#FROM ubuntu:latest AS runtime
# We do not need the Rust toolchain to run the binary!
#RUN apt-get update -y && apt-get upgrade -y
#WORKDIR /navigatum-server
#COPY --from=build /navigatum-server/data/ ./data/
#COPY --from=build /navigatum-server/target/debug/navigatum-server ./navigatum-server
#EXPOSE 8080
#HEALTHCHECK --start-period=3m  --timeout=10s CMD curl localhost:8080/api/health
#CMD ./navigatum-server && ldd ./navigatum-server && tail -f /dev/null