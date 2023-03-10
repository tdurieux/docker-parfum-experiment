FROM docker.io/rust:1-slim-bullseye as cargo-build
WORKDIR /usr/local/src/gp-v2-services

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y git libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

# Copy and Build Code
COPY . .
RUN CARGO_PROFILE_RELEASE_DEBUG=1 cargo build --release

# Extract Binary
FROM docker.io/debian:bullseye-slim

# Handle signal handlers properly
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates tini && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=cargo-build /usr/local/src/gp-v2-services/target/release/orderbook /usr/local/bin/orderbook
COPY --from=cargo-build /usr/local/src/gp-v2-services/target/release/solver /usr/local/bin/solver
COPY --from=cargo-build /usr/local/src/gp-v2-services/target/release/alerter /usr/local/bin/alerter

CMD echo "Specify binary - either solver or orderbook"
ENTRYPOINT ["/usr/bin/tini"]
