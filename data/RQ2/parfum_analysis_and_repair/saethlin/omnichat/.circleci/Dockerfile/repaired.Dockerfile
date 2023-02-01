FROM debian:unstable

RUN apt-get update && apt-get install --no-install-recommends git make lld musl-dev musl-tools curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get full-upgrade -y
RUN apt-get autoremove -y


ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl https://sh.rustup.rs -sSf > rustup-init
RUN sh rustup-init -y
RUN rustup target add x86_64-unknown-linux-musl
ENV RUSTFLAGS="-Clinker=lld"

