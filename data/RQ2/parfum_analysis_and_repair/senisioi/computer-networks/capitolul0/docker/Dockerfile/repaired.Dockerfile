FROM ubuntu:20.04

MAINTAINER Sergiu Nisioi <sergiu.nisioi@fmi.unibuc.ro>

USER root


RUN export DEBIAN_FRONTEND=noninteractive && \
           apt-get update && \
           apt-get install --no-install-recommends -y build-essential \
                                         git \
                                         net-tools \
                                         arp-scan \
                                         python3.8 \
                                         python3-pip \
                                         tcpdump \
                                         ethtool \
                                         nmap \
                                         netcat \
                                         traceroute \
                                         iputils-ping \
                                         dnsutils \
                                         iptables \
                                         iproute2 \
                                         libnetfilter-queue-dev && rm -rf /var/lib/apt/lists/*;


RUN pip3 install --no-cache-dir --pre scapy[complete]
RUN pip3 install --no-cache-dir cryptography bs4 connexion[swagger-ui] flask
RUN pip3 install --no-cache-dir python-iptables cython

RUN git clone https://github.com/kti/python-netfilterqueue
RUN cd python-netfilterqueue && python3 setup.py install

