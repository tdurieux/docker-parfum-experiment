FROM rust:latest
RUN mkdir /code
WORKDIR /code
COPY . .
RUN cargo build --release -p git-release-name-web

FROM debian:stretch-slim
RUN mkdir /app
WORKDIR /app
COPY --from=0 /code/target/release/git-release-name-web /app/git-release-name-web
EXPOSE 6767
STOPSIGNAL 15
CMD ["./git-release-name-web"]