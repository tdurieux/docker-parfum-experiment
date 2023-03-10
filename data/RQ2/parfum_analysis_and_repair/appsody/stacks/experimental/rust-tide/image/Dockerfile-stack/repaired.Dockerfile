FROM rust:1.44.0-buster

RUN apt-get update && apt-get install --no-install-recommends -y gdbserver && rm -rf /var/lib/apt/lists/*;

ENV CARGO_HOME=/usr/local/cargo/deps

ENV APPSODY_MOUNTS=/:/project/user-app
ENV APPSODY_DEPS=$CARGO_HOME
ENV APPSODY_WATCH_DIR=/project/user-app
ENV APPSODY_WATCH_REGEX="^(Cargo.toml|.*.rs)$"
ENV APPSODY_WATCH_IGNORE_DIR=/project/server/bin/target;/project/user-app/target
ENV APPSODY_PROJECT_DIR=/project
ENV APPSODY_RUN="cargo run --manifest-path ../server/bin/Cargo.toml"
ENV APPSODY_RUN_ON_CHANGE=$APPSODY_RUN
ENV APPSODY_RUN_KILL=true

ENV APPSODY_DEBUG="cargo build --manifest-path ../server/bin/Cargo.toml && gdbserver localhost:1234 /project/server/bin/target/debug/rust-tide-server"
ENV APPSODY_DEBUG_ON_CHANGE="$APPSODY_DEBUG"
ENV APPSODY_DEBUG_KILL=true
ENV APPSODY_DEBUG_PORT=1234

ENV APPSODY_TEST="/project/test-stack.sh"
ENV APPSODY_TEST_ON_CHANGE=$APPSODY_TEST
ENV APPSODY_TEST_KILL=true

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config

WORKDIR /project/user-app

# Expose the relevant ports (change this to be specific to your application).
ENV PORT=8000

EXPOSE 8000
EXPOSE 1234