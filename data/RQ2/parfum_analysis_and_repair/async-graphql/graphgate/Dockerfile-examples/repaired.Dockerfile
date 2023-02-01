FROM rust:1.50 as builder
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY . /tmp
WORKDIR /tmp
RUN cargo build --examples --release

FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /tmp/target/release/examples/accounts /usr/bin/accounts
COPY --from=builder /tmp/target/release/examples/products /usr/bin/products
COPY --from=builder /tmp/target/release/examples/reviews /usr/bin/reviews
