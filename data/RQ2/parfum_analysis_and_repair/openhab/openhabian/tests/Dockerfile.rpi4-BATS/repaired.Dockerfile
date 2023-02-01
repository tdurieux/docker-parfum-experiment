# Note RPi4 base WITH 64bit OS
FROM balenalib/raspberrypi4-64-debian:bullseye-build

ENV DOCKER=1

# BATS tests on a minimal install will require additional packages
# to run properly:
# - lsb-release (influx, homegear)
# - apt-transport-https (homegear)
# those packages would normally be included in our standard install
RUN apt-get update -qq && \
    apt-get dist-upgrade && \
    apt-get install --yes -qq --no-install-recommends git wget python3 \
        python3-pip apt-utils jq lsb-release apt-transport-https gnupg acl && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/gdraheim/docker-systemctl-replacement && \
    cp docker-systemctl-replacement/files/docker/systemctl3.py /usr/bin/systemctl

# Setup openHABian environment