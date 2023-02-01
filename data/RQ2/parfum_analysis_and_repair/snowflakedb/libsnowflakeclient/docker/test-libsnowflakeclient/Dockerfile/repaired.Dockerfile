FROM ubuntu:16.04

ARG SNOWSQL_VERSION=1.1.53
ARG PROXY_IP=172.20.128.10
ARG PROXY_PORT=3128

RUN apt-get update -q -y
RUN apt-get upgrade -q -y
RUN apt-get install --no-install-recommends -q -y iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y git vim cmake pkg-config curl gcc g++ zlib1g-dev jq lcov && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y language-pack-en-base software-properties-common && rm -rf /var/lib/apt/lists/*;

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

COPY iptables.txt /root
RUN echo "source ~/iptables.txt" >> /root/.bashrc

ENV http_proxy http://${PROXY_IP}:${PROXY_PORT}
ENV https_proxy http://${PROXY_IP}:${PROXY_PORT}
ENV HTTP_PROXY http://${PROXY_IP}:${PROXY_PORT}
ENV HTTPS_PROXY http://${PROXY_IP}:${PROXY_PORT}

COPY build_run_libsnowflakeclient_proxy_test.sh /root
