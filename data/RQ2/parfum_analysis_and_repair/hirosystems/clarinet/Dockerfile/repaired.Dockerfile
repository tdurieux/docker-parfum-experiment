FROM rust:stretch as build

WORKDIR /src

RUN apt update && apt install --no-install-recommends -y ca-certificates pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN rustup update 1.59.0 && rustup default 1.59.0

COPY . .

RUN mkdir /out

RUN cargo build --features=telemetry --release --locked

RUN cp target/release/clarinet /out

FROM debian:stretch-slim

RUN apt update && apt install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=build /out/ /bin/

WORKDIR /workspace

ENV CLARINET_MODE_CI=1

ENTRYPOINT ["clarinet"]
