FROM ubuntu:18.04

RUN mkdir /tmp/tests \
 && apt-get -y update \
 && apt-get -y --no-install-recommends install python3 python3-pip \
 && pip3 install --no-cache-dir nose && rm -rf /var/lib/apt/lists/*;

COPY dist/* /tmp/
COPY tests /tmp/tests/
