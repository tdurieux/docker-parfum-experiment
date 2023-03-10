FROM ghcr.io/nestybox/alpine-docker-dbg:latest

RUN mkdir /etc/docker && \
    echo -e "{\n" \
    "  \"debug\": true,\n" \
    "  \"default-address-pools\": [\n" \
    "      {\n" \
    "           \"base\": \"172.25.0.0/16\",\n" \
    "           \"size\": 24\n" \
    "      }\n" \
    "   ],\n" \
    "  \"data-root\": \"/var/lib/different-docker-data-root\",\n" \
    "  \"bip\": \"172.21.0.1/16\"\n" \
    "}\n" > /etc/docker/daemon.json