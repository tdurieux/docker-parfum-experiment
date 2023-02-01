# this container builds the kilt-parachain binary from source files and the runtime library
# pinned the version to avoid build cache invalidation

# Corresponds to paritytech/ci-linux:production at the time of this PR
# https://hub.docker.com/layers/ci-linux/paritytech/ci-linux/production/images/sha256-c75cee0971ca54e57a875fac8714eea2db754e621841cde702478783fc28ab90?context=explore
FROM paritytech/ci-linux@sha256:c75cee0971ca54e57a875fac8714eea2db754e621841cde702478783fc28ab90 as builder

WORKDIR /build

ARG FEATURES=default

COPY . .

RUN cargo build --locked --release --features $FEATURES

# ===== SECOND STAGE ======