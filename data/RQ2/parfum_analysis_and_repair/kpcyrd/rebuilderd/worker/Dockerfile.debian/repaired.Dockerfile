FROM rust:bullseye
WORKDIR /usr/src/rebuilderd
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN --mount=type=cache,target=/var/cache/buildkit \
    CARGO_HOME=/var/cache/buildkit/cargo \
    CARGO_TARGET_DIR=/var/cache/buildkit/debian/target \
    cargo build --release --locked -p rebuilderd-worker && \
    cp -v /var/cache/buildkit/debian/target/release/rebuilderd-worker /

FROM debian:bullseye
RUN apt-get update && apt install --no-install-recommends -y libssl-dev git mmdebstrap diffoscope \
    python3-apt python3-dateutil python3-requests python3-rstr python3-setuptools python3-httpx python3-tenacity \
    debian-keyring debian-archive-keyring debian-ports-archive-keyring && rm -rf /var/lib/apt/lists/*;
# this is a temporary solution
# copied from https://github.com/fepitre/package-rebuilder/blob/fc38df2f6e81ae6307e47cf515caa3e92ec8f5a4/rebuilder.Dockerfile
RUN git clone https://salsa.debian.org/python-debian-team/python-debian /opt/python-debian
RUN cd /opt/python-debian && git checkout e28d7a5729b187cfd0ec95da25030224cd10021a && python3 setup.py build install
RUN git clone --depth=1 'https://github.com/fepitre/debrebuild' /debrebuild
COPY --from=0 \
    /usr/src/rebuilderd/worker/rebuilder-debian.sh \
    /usr/local/libexec/rebuilderd/
COPY --from=0 /rebuilderd-worker /usr/local/bin/
ENV REBUILDERD_WORKER_BACKEND=debian=/usr/local/libexec/rebuilderd/rebuilder-debian.sh
ENTRYPOINT ["rebuilderd-worker"]
