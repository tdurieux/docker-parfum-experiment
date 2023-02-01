FROM ubuntu-upstart

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends --yes python-minimal python-pip python-dev iproute2 && rm -rf /var/lib/apt/lists/*;

