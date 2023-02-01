FROM debian:buster-slim
RUN apt-get update && apt-get update -y && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT [ "curl" ]
