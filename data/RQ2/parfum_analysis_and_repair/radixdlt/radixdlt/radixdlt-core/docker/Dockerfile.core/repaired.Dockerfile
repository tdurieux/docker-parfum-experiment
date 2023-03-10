FROM ubuntu:21.04
MAINTAINER radixdlt <devops@radixdlt.com>

#https://issueexplorer.com/issue/tianon/docker-brew-ubuntu-core/207
#bug https://bugs.launchpad.net/cloud-images/+bug/1928218
COPY apt-config/sources.list /etc/apt/
COPY apt-config/99own /etc/apt/apt.conf.d/

RUN apt-get -y update > /dev/null && \
    apt-get -y --no-install-recommends install apt-utils net-tools iptables iproute2 gettext-base curl tcpdump strace attr software-properties-common daemontools > /dev/null && \
    apt-get clean > /dev/null && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

COPY scripts/fix-vulnerabilities.sh /tmp
RUN /tmp/fix-vulnerabilities.sh

RUN apt-get -y --no-install-recommends install openjdk-17-jdk && rm -rf /var/lib/apt/lists/*;

# set entrypoint and default command
ENTRYPOINT ["/opt/radixdlt/config_radixdlt.sh"]
CMD ["/opt/radixdlt/bin/radixdlt"]

# set default environment variables
ENV RADIXDLT_HOME=/home/radixdlt \
    RADIXDLT_NETWORK_SEEDS_REMOTE=127.0.0.1 \
    RADIXDLT_DB_LOCATION=./RADIXDB \
    RADIXDLT_VALIDATOR_KEY_LOCATION=/home/radixdlt/node.ks \
    RADIXDLT_TRANSACTIONS_API_ENABLE=false \
    RADIXDLT_SIGN_ENABLE=false\
    RADIXDLT_NETWORK_USE_PROXY_PROTOCOL=false \
    RADIXDLT_API_PORT=3333 \
    RADIXDLT_HTTP_BIND_ADDRESS=0.0.0.0 \
    RADIXDLT_NETWORK_ID=99

# install the radixdlt package
COPY *.deb /tmp/
RUN dpkg -i /tmp/*.deb

# create configuration automatically when starting
COPY scripts/config_radixdlt.sh /opt/radixdlt/config_radixdlt.sh

# copy configuration templates
WORKDIR /home/radixdlt
COPY config/ /home/radixdlt/

# Add healthcheck
COPY scripts/docker-healthcheck.sh /home/radixdlt/
HEALTHCHECK CMD sh /home/radixdlt/docker-healthcheck.sh
RUN chmod +x /home/radixdlt/docker-healthcheck.sh
