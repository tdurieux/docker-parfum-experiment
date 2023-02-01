FROM debian:8

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends --yes python-minimal python-pip && \
    rm /lib/systemd/system/getty@.service && rm -rf /var/lib/apt/lists/*;
