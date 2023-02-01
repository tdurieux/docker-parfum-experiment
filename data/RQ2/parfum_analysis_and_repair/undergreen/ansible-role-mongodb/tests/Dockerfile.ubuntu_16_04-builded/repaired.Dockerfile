FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends --yes python-minimal python-pip python-dev iproute2 && \
    rm /lib/systemd/system/getty@.service && rm -rf /var/lib/apt/lists/*;

