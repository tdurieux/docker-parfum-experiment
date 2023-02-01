FROM rust:1.59

RUN apt-get update -y && apt-get install --no-install-recommends libudev-dev libssl-dev pkg-config -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src
COPY spl-token ./spl-token

ARG FLAG
ENV FLAG=$FLAG

RUN cargo build --release

COPY darksols.so evil-contract.so ./

EXPOSE 8080

CMD [ "./target/release/dark-sols" ]

