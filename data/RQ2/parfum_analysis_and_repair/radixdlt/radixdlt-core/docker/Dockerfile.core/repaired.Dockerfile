FROM ubuntu:20.04
MAINTAINER radixdlt <devops@radixdlt.com>

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install net-tools iptables gettext-base curl tcpdump strace attr software-properties-common openjdk-11-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# set entrypoint and default command
ENTRYPOINT [ "/opt/radixdlt/config_radixdlt.sh" ]
CMD ["/bin/bash", "-xe", "/opt/radixdlt/bin/radixdlt"]

# set default environment variables
ENV RADIXDLT_HOME=/home/radixdlt \
    RADIXDLT_CP_PORT=8080 \
    RADIXDLT_NETWORK_SEEDS_REMOTE=127.0.0.1 \
    RADIXDLT_PACEMAKER_TIMEOUT_MILLIS=5000 \
    RADIXDLT_CONSENSUS_START_ON_BOOT=true

# install the radixdlt package
COPY *.deb /tmp/
RUN dpkg -i /tmp/*.deb

# create configuration automatically when starting
COPY scripts/config_radixdlt.sh /opt/radixdlt/config_radixdlt.sh

# copy configuration templates
WORKDIR /home/radixdlt
COPY config/ /home/radixdlt/
RUN chown -R radixdlt:radixdlt /home/radixdlt/