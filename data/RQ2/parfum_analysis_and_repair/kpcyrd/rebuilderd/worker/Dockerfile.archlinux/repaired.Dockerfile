FROM archlinux
WORKDIR /usr/src/rebuilderd
RUN pacman -Suy --noconfirm gcc pkgconf cargo openssl
COPY . .
RUN --mount=type=cache,target=/var/cache/buildkit \
    CARGO_HOME=/var/cache/buildkit/cargo \
    CARGO_TARGET_DIR=/var/cache/buildkit/archlinux/target \
    cargo build --release --locked -p rebuilderd-worker && \
    cp -v /var/cache/buildkit/archlinux/target/release/rebuilderd-worker /

FROM archlinux
RUN pacman -Suy --noconfirm archlinux-repro openssl
COPY --from=0 \
    /usr/src/rebuilderd/worker/rebuilder-archlinux.sh \
    /usr/local/libexec/rebuilderd/
COPY --from=0 /rebuilderd-worker /usr/local/bin/
ENV REBUILDERD_WORKER_BACKEND=archlinux=/usr/local/libexec/rebuilderd/rebuilder-archlinux.sh
ENTRYPOINT ["rebuilderd-worker"]