FROM debian:buster-slim
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y ca-certificates libssl-dev libssl1.1 && rm -rf /var/lib/apt/lists/*;
COPY --from=swir_builder:latest /swir/target/release/swir /swir
ARG swir_config
COPY $swir_config /swir.yaml
ENV RUST_BACKTRACE=full
ENV RUST_LOG=info,rusoto_core=info,swir=info,rusoto_dynamodb=info
EXPOSE 8080 8090 50051
ENTRYPOINT ["./swir"]