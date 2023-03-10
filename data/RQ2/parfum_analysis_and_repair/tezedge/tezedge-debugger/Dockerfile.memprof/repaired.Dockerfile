FROM tezedge/tezedge-bpf-builder:latest as builder

RUN cargo install bpf-linker --git https://github.com/tezedge/bpf-linker.git --branch main && \
    DEBIAN_FRONTEND='noninteractive' apt-get --no-install-recommends install -y libelf-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-20.10.6.tgz && \
    tar xzf docker-20.10.6.tgz --strip 1 -C /usr/bin docker/docker && \
    rm docker-*.tgz

COPY . .
RUN cargo build -p bpf-memprof --release

FROM tezedge/tezedge-libs:latest-profile

COPY --from=builder /usr/lib/x86_64-linux-gnu/libelf.so.1 /usr/lib/x86_64-linux-gnu/libelf.so.1
COPY --from=builder /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=builder /home/appuser/target/none/release/bpf-memprof-user /usr/bin/bpf-memprof-user

COPY --from=builder /usr/bin/docker /usr/bin/docker

ENTRYPOINT ["bpf-memprof-user"]
