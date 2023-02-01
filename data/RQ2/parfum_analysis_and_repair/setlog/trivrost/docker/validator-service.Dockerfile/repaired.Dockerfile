FROM debian:11-slim
LABEL maintainer="Setlog <info@setlog.com>"
COPY out/validator .
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["./validator", "--act-as-service"]
