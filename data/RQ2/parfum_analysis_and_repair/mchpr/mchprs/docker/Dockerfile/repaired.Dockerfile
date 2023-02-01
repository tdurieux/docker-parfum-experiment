FROM rustlang/rust:nightly-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    git pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/MCHPR/MCHPRS.git
WORKDIR ./MCHPRS
RUN cargo install --path . \
    && cargo clean

VOLUME ["/data"]
WORKDIR /data

CMD ["mchprs"]