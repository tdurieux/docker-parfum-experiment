FROM rust:1.61

RUN apt update && \
    apt install --no-install-recommends -y libopenblas-dev && rm -rf /var/lib/apt/lists/*;

RUN rustup component add rustfmt

RUN cargo install moose
