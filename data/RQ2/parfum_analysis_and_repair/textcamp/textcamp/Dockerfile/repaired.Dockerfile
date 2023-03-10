FROM rust:latest as build

RUN apt-get update
RUN apt-get install --no-install-recommends -y openssl libssl-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/textcamp

COPY . .

RUN cargo build --release

FROM rust:slim

RUN apt-get update
RUN apt-get install --no-install-recommends -y openssl libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=build /usr/src/textcamp/site /usr/textcamp/site
COPY --from=build /usr/src/textcamp/world /usr/textcamp/world
COPY --from=build /usr/src/textcamp/.env /usr/textcamp/.env
COPY --from=build /usr/src/textcamp/target/release/server /usr/textcamp/server

WORKDIR /usr/textcamp

ENV PATH=/usr/textcamp:$PATH
ENV RUST_LOG=info

CMD ["./server"]
