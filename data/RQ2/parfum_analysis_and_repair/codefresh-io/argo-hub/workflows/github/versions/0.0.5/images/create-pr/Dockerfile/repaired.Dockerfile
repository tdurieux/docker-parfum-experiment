FROM debian:stable-slim
RUN apt update -y && apt install --no-install-recommends git curl hub=2.14.2~ds1-1+b4 -y && rm -rf /var/lib/apt/lists/*
ENTRYPOINT hub
