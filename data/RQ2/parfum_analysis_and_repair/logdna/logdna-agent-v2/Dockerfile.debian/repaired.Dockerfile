ARG BUILD_IMAGE

FROM --platform=${BUILDPLATFORM} ${BUILD_IMAGE} as build

ENV _RJEM_MALLOC_CONF="narenas:1,tcache:false,dirty_decay_ms:0,muzzy_decay_ms:0"
ENV JEMALLOC_SYS_WITH_MALLOC_CONF="narenas:1,tcache:false,dirty_decay_ms:0,muzzy_decay_ms:0"

ARG FEATURES

ARG SCCACHE_BUCKET
ARG SCCACHE_REGION
ARG SCCACHE_ENDPOINT
ARG SCCACHE_SERVER_PORT=4226
ARG SCCACHE_RECACHE
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

ENV RUST_LOG=rustc_codegen_ssa::back::link=info

# Create the directory for agent repo
WORKDIR /opt/logdna-agent-v2

# Add the actual agent source files
COPY . .

# Rebuild the agent
# hadolint ignore=SC1091
RUN --mount=type=secret,id=aws,target=/root/.aws/credentials \
    --mount=type=cache,target=/opt/rust/cargo/registry \
    --mount=type=cache,target=/opt/logdna-agent-v2/target \
    set -a; \
    if [ -z "$SCCACHE_BUCKET" ]; then unset RUSTC_WRAPPER; fi; \
    if [ -z "$SCCACHE_ENDPOINT" ]; then unset SCCACHE_ENDPOINT; fi; \
    if [ -z "$SCCACHE_RECACHE" ]; then unset SCCACHE_RECACHE; fi; \
    set +a && env && \
    cargo build --manifest-path bin/Cargo.toml ${FEATURES} --release && \
    strip ./target/release/logdna-agent && \
    cp ./target/release/logdna-agent /logdna-agent && \
    sccache --show-stats

# Use Debian as agent base image
FROM debian:bullseye

ARG REPO
ARG BUILD_TIMESTAMP
ARG VCS_REF
ARG VCS_URL
ARG BUILD_VERSION

LABEL org.opencontainers.image.created="${BUILD_TIMESTAMP}"
LABEL org.opencontainers.image.authors="LogDNA <support@logdna.com>"
LABEL org.opencontainers.image.url="https://logdna.com"
LABEL org.opencontainers.image.documentation=""
LABEL org.opencontainers.image.source="${VCS_URL}"
LABEL org.opencontainers.image.version="${BUILD_VERSION}"
LABEL org.opencontainers.image.revision="${VCS_REF}"
LABEL org.opencontainers.image.vendor="LogDNA Inc."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.ref.name=""
LABEL org.opencontainers.image.title="LogDNA Agent"
LABEL org.opencontainers.image.description="The blazingly fast, resource efficient log collection client"

ENV DEBIAN_FRONTEND=noninteractive
ENV _RJEM_MALLOC_CONF="narenas:1,tcache:false,dirty_decay_ms:0,muzzy_decay_ms:0"
ENV JEMALLOC_SYS_WITH_MALLOC_CONF="narenas:1,tcache:false,dirty_decay_ms:0,muzzy_decay_ms:0"

# Copy the agent binary from the build stage
COPY --from=build /logdna-agent /work/
WORKDIR /work/

RUN apt update -y \
    && apt upgrade -y \
    && apt auto-remove -y \
    && apt install -y --no-install-recommends ca-certificates libcap2-bin \
                   netcat-openbsd nmap dnsutils vim curl procps net-tools \
                   gdbserver \
    && rm -rf /var/cache/apt \
    && chmod -R 777 . \
    && setcap "cap_dac_read_search+p" /work/logdna-agent \
    && groupadd -g 5000 logdna \
    && useradd -u 5000 -g logdna logdna && rm -rf /var/lib/apt/lists/*;


CMD ["./logdna-agent"]
