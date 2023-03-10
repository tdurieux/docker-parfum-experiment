FROM rustlang/rust:nightly

ENV CARGO_HOME=/usr/local/cargo/deps
ENV CARGO_TARGET_DIR=$CARGO_HOME/target

ENV APPSODY_MOUNTS=/Cargo.toml:/project/copy/Cargo.toml;/src:/project/user-app/src/
ENV APPSODY_DEPS=$CARGO_HOME
ENV APPSODY_PROJECT_DIR=/project

ENV APPSODY_WATCH_DIR="/project/user-app"
ENV APPSODY_WATCH_IGNORE_DIR="/project/user-app/.appsody"
ENV APPSODY_WATCH_REGEX="(^.*.rs$)"

ENV ROCKET_ADDRESS=0.0.0.0 
ENV ROCKET_PORT=8000 

ENV APPSODY_PREP="cp /project/copy/Cargo.toml /project/user-app/Cargo.toml && cargo add -q appsody-rocket --path=../deps"

ENV APPSODY_RUN="cargo run"
ENV APPSODY_RUN_ON_CHANGE="cargo run"
ENV APPSODY_RUN_KILL=true

ENV APPSODY_TEST="cargo test -p appsody-rocket && cargo test"

COPY ./LICENSE /licenses
COPY ./project /project
COPY ./config /config

WORKDIR /project/deps

RUN cp /project/cargo-add /usr/local/cargo/bin && cargo fetch

WORKDIR /project/user-app

ENV PORT=8000

EXPOSE 8000