FROM debian:9

RUN apt-get update && \
    apt-get -y install \
      python \
      git \
      curl && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    pip install --upgrade cryptography && \
    mkdir -p ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

ADD wpkpack.py /usr/local/bin/wpkpack
ADD run.sh /usr/local/bin/run
ADD gen_versions.sh /usr/local/bin/gen_versions
VOLUME /var/local/wazuh
VOLUME /etc/wazuh
ENTRYPOINT ["/usr/local/bin/run"]
