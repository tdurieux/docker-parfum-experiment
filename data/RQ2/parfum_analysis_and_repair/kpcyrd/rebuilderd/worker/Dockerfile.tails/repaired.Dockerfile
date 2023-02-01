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
RUN apt-get update && apt-get install --no-install-recommends -y libssl1.1 dpkg-dev sudo \
    psmisc git rake libvirt-daemon-system dnsmasq-base ebtables faketime pigz qemu-system-x86 qemu-utils vagrant vagrant-libvirt vmdb2 && rm -rf /var/lib/apt/lists/*;
COPY --from=0 \
    /usr/src/rebuilderd/worker/rebuilder-tails.sh \
    /usr/local/libexec/rebuilderd/
COPY --from=0 /rebuilderd-worker /usr/local/bin/
ENV REBUILDERD_WORKER_BACKEND=tails=/usr/local/libexec/rebuilderd/rebuilder-tails.sh
ENTRYPOINT ["rebuilderd-worker"]
