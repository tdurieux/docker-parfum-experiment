ARG TARGETARCH
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT


FROM rust:1.57 as builder

WORKDIR /app
COPY . .
RUN apt update && \
 apt install --no-install-recommends -y build-essential gcc make cmake cmake-gui cmake-curses-gui libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN cargo build --release

FROM debian

WORKDIR /app
RUN apt update && \
 apt install --no-install-recommends -y build-essential gcc make cmake cmake-gui cmake-curses-gui libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /app/target/release/chronicle ./chronicle

ENTRYPOINT ["/app/chronicle"]
