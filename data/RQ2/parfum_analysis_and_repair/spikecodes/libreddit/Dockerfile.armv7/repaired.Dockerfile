####################################################################################################
## Builder
####################################################################################################
FROM --platform=$BUILDPLATFORM rust:slim AS builder

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER=arm-linux-gnueabihf-gcc
ENV CC_armv7_unknown_linux_musleabihf=arm-linux-gnueabihf-gcc

RUN apt-get update && apt-get -y --no-install-recommends install gcc-arm-linux-gnueabihf \
    binutils-arm-linux-gnueabihf \
    musl-tools && rm -rf /var/lib/apt/lists/*;

RUN rustup target add armv7-unknown-linux-musleabihf

WORKDIR /libreddit

COPY . .

RUN cargo build --target armv7-unknown-linux-musleabihf --release

####################################################################################################
## Final image
####################################################################################################
FROM alpine:latest

# Import ca-certificates from builder
COPY --from=builder /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

# Copy our build
COPY --from=builder /libreddit/target/armv7-unknown-linux-musleabihf/release/libreddit /usr/local/bin/libreddit

# Use an unprivileged user.
RUN adduser --home /nonexistent --no-create-home --disabled-password libreddit
USER libreddit

# Tell Docker to expose port 8080
EXPOSE 8080

# Run a healthcheck every minute to make sure Libreddit is functional
HEALTHCHECK --interval=1m --timeout=3s CMD wget --spider --q http://localhost:8080/settings || exit 1

CMD ["libreddit"]
