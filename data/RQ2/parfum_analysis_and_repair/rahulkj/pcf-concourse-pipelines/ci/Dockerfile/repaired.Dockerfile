FROM ubuntu:19.04
MAINTAINER rahulkj@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y vim curl wget git \
    jq python nano unzip uuid-runtime iputils-ping dnsutils \
    ca-certificates netcat telnet ruby && rm -rf /var/lib/apt/lists/*;

RUN ruby -v
