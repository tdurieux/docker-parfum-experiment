FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends --yes gcc git curl file make libncurses5-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh -s -- -y --channel=nightly --disable-sudo

COPY . /code

WORKDIR /code

ENV CODE_DIR=/code

ENV WORK_DIR=/tmp

ENV PKG_NAME=infinite-pipe

ENV RUST_BACKTRACE=1

CMD ./packagers/debian/build.sh
