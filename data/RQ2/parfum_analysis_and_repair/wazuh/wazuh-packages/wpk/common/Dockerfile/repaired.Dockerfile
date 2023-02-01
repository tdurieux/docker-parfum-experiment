FROM debian:9

RUN apt-get update && \
    apt-get -y --no-install-recommends install python git curl jq python3 python3-pip && \
    pip3 install --no-cache-dir --upgrade cryptography==2.9.2 awscli && rm -rf /var/lib/apt/lists/*;

ADD wpkpack.py /usr/local/bin/wpkpack
ADD run.sh /usr/local/bin/run
VOLUME /var/local/wazuh
VOLUME /etc/wazuh
VOLUME /etc/wazuh/checksum
ENTRYPOINT ["/usr/local/bin/run"]
