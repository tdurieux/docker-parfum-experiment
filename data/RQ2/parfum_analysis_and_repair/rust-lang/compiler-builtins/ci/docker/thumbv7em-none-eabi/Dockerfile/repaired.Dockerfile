FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc libc6-dev ca-certificates \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi && rm -rf /var/lib/apt/lists/*;
ENV XARGO=1
