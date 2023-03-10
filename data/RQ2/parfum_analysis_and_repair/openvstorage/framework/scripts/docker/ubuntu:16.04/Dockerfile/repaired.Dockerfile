# Download base image ubuntu 16.04
FROM ubuntu:16.04

# Update Ubuntu Software repository
RUN apt-get update \
    && apt-get install --no-install-recommends -y --force-yes \
        rsyslog \
        sudo \
        openssl \
        acl && rm -rf /var/lib/apt/lists/*;
