FROM ubuntu:focal

RUN apt-get update && apt-get install --no-install-recommends -y \
    net-tools \
    iputils-ping \
    iproute2 \
    curl && rm -rf /var/lib/apt/lists/*;
