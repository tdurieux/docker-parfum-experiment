FROM rust:1.57

RUN apt update; apt install --no-install-recommends graphviz gcc libssl-dev libsqlite3-dev -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/doteur

COPY ./ .

RUN cargo install --path doteur_cli --all-features

RUN rm -rf ./*

COPY ./samples .
