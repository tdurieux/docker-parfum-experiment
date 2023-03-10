FROM alexcrichton/port-prebuilt-freebsd:2017-09-16

RUN apt-get -y update && apt-get -y --no-install-recommends install curl gcc && rm -rf /var/lib/apt/lists/*;

ENV CARGO_HOME=/usr/local/cargo \
    RUSTUP_HOME=/usr/local/rustup \
    PATH=/usr/local/cargo/bin:$PATH

COPY support/install-rust.sh /tmp/
RUN sh /tmp/install-rust.sh x86_64-unknown-freebsd
COPY x86_64-unknown-freebsd/cargo-config /.cargo/config
