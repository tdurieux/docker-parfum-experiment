FROM opxhub/build:latest
RUN apt-get update && apt-get install -y --no-install-recommends \
      libdbus-1-dev \
      libsystemd-dev \
      libopx-base-model-dev \
      libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY build_hsflowd /root/build_hsflowd
ENTRYPOINT ["/root/build_hsflowd"]
