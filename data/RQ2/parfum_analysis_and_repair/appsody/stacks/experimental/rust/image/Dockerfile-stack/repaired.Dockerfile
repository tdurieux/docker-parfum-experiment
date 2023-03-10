FROM rust:1.40

RUN apt-get update && apt-get install --no-install-recommends -y lldb musl-tools && rm -rf /var/lib/apt/lists/*;
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo install sccache

ENV CARGO_HOME=/usr/local/cargo/deps
ENV SCCACHE_DIR=/project/sccache
ENV RUSTC_WRAPPER=sccache

ENV APPSODY_MOUNTS=.:/project/user-app;~/.cache/sccache:/project/sccache
ENV APPSODY_DEPS=$CARGO_HOME

ENV APPSODY_WATCH_DIR="/project/user-app"
ENV APPSODY_WATCH_REGEX="^(Cargo.toml|.*.rs)$"

ENV APPSODY_RUN="cargo run --target x86_64-unknown-linux-musl"
ENV APPSODY_RUN_ON_CHANGE="$APPSODY_RUN"
ENV APPSODY_RUN_KILL=true

ENV APPSODY_TEST="cargo test"

ENV APPSODY_DEBUG="cargo build --target x86_64-unknown-linux-musl && lldb-server platform --listen '*:1234' --min-gdbserver-port 5000 --max-gdbserver-port 5001 --server"
ENV APPSODY_DEBUG_ON_CHANGE="$APPSODY_DEBUG"
ENV APPSODY_DEBUG_KILL=true

COPY ./LICENSE /licenses
COPY ./project /project
COPY ./config /config

WORKDIR /project/user-app

ENV PORT=8000

EXPOSE 8000
EXPOSE 1234
EXPOSE 5000
