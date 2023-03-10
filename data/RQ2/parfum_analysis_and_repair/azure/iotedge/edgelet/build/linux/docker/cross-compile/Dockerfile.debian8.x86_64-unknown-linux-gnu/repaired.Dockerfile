FROM debian:8.11-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    software-properties-common \
    build-essential \
    ca-certificates \
    uuid-dev \
    curl \
    openssl \
    libssl-dev \
    libcurl4-openssl-dev \
    debhelper \
    dh-systemd \
    pkg-config && rm -rf /var/lib/apt/lists/*;

COPY apt/cmake.sh /                                                      
RUN apt-get purge --auto-remove -y cmake && \                         
    bash /cmake.sh 3.11.4
