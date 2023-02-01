FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y libreadline-dev libncurses5-dev libpcre3-dev \
    libssl-dev perl make build-essential wget zlib1g-dev && rm -rf /var/lib/apt/lists/*;