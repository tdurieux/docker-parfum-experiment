FROM ubuntu:14.04

RUN apt-get update && \
    apt-get -y --no-install-recommends install openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean all

ADD makeca.sh /tmp/makeca.sh
RUN chmod +x /tmp/makeca.sh && \
    mkdir /tmp/ca
WORKDIR /tmp/ca

ENTRYPOINT ["/tmp/makeca.sh"]
