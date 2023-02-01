FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -yqq update && apt-get -yqq upgrade && apt-get -yqq install \
    --no-install-suggests --no-install-recommends \
    apt-utils \
    mongodb \
    mongodb-clients \
    mongo-tools \
    python3-pip \
    python3-wheel \
    python3.8 \
    python3.8-dev \
    net-tools && rm -rf /var/lib/apt/lists/*;

COPY . /OWASP-Honeypot
WORKDIR /OWASP-Honeypot

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir -r requirements-dev.txt
