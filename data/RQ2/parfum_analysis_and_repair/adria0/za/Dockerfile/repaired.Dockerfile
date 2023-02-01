FROM alpine:edge AS builder

RUN apk add --no-cache build-base \
    cmake \
    linux-headers \
    openssl-dev \
    cargo \
    clang \
    clang-libs \
    git

WORKDIR /home/rust/
COPY . .
RUN cargo build --release

FROM alpine:edge
WORKDIR /home/rust/
COPY --from=builder /home/rust/target/release/circom2 .

RUN apk add --no-cache clang clang-libs ca-certificates

ENTRYPOINT ["./circom2"]
