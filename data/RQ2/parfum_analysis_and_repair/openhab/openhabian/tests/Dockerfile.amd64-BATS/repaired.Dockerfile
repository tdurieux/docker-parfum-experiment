FROM balenalib/generic-debian:bullseye-build

ENV DOCKER=1

# BATS tests on a minimal install will require additional packages
# to run properly:
# - lsb-release (influx, homegear)
# - apt-transport-https (homegear)
# those packages would normally be included in our standard install
RUN apt-get update -qq && \
    apt-get install --yes -qq --no-install-recommends git wget python3 \
        python3-pip apt-utils jq lsb-release apt-transport-https gnupg acl && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/gdraheim/docker-systemctl-replacement && \
    cp docker-systemctl-replacement/files/docker/systemctl3.py /usr/bin/systemctl

# Setup openHABian environment
RUN git clone https://github.com/bats-core/bats-core.git --branch v1.5.0 && \
    cd bats-core && \
    ./install.sh /usr/local

RUN adduser openhabian --gecos "openHABian,,," --disabled-password && \
    adduser openhab --gecos "openHABian,,," --disabled-password && \
    echo "openhabian:openhabian" | chpasswd && \
    echo "openhab:openhabian" | chpasswd

COPY . /opt/openhabian/
WORKDIR /opt/openhabian/
RUN install -m 755 ./tests/runlevel /sbin/runlevel

ENTRYPOINT ["/usr/bin/systemctl"]