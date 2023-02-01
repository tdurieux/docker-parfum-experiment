FROM debian:latest

RUN apt-get update && apt-get install --no-install-recommends -y \
    hping3 \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["hping3"]
