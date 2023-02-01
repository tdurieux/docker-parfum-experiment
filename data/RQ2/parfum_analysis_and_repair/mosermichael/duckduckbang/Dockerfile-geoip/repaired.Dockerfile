FROM alpine:3.12

ARG GITHUB_TOKEN=""

RUN apk add --no-cache bash python3 git expect py3-pip
RUN pip3 install --no-cache-dir python-geoip
RUN pip3 install --no-cache-dir python-geoip-geolite2
RUN pip3 install --no-cache-dir maxminddb
RUN pip3 install --no-cache-dir maxminddb-geolite2
RUN pip3 install --no-cache-dir dataclasses-json





