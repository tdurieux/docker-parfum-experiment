ARG FROM=docker.io/debian:bullseye
FROM ${FROM}

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --no-install-recommends -y sudo git build-essential && \
    groupadd wheel && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/wheelers && rm -rf /var/lib/apt/lists/*;