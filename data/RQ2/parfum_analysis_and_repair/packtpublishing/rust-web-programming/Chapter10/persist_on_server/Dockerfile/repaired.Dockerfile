FROM rust:1.43.1

RUN apt-get update -yqq && apt-get install --no-install-recommends -yqq cmake g++ && rm -rf /var/lib/apt/lists/*;
RUN cargo install diesel_cli --no-default-features --features postgres

COPY ./css ./css
COPY ./javascript ./javascript
COPY ./migrations ./migrations
COPY ./src ./src
COPY ./templates ./templates
COPY ./.env ./.env
COPY ./Cargo.toml ./Cargo.toml
COPY ./diesel.toml ./diesel.toml

WORKDIR .

RUN cargo build --release

EXPOSE 8000

CMD ["cargo", "run", "--release"]
