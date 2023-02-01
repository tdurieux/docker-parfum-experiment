FROM iteringops/darwinia-builder:latest as builder

COPY . /source
WORKDIR /source

ENV TERM="xterm-256color"

RUN ./build.sh && cargo build --release

FROM debian:stable-slim

RUN apt-get update && apt-get -y --no-install-recommends install openssl && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /source/target/release/darwinia-appchain /usr/local/bin/.

EXPOSE 30333 9933 9944
VOLUME ["/data"]

ENTRYPOINT [ "/usr/local/bin/darwinia-appchain" ]
CMD ["--dev"]


