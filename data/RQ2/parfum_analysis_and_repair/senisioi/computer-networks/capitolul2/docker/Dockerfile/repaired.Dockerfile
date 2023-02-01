FROM kalilinux/kali-rolling

MAINTAINER Sergiu Nisioi <sergiu.nisioi@fmi.unibuc.ro>

USER root

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git net-tools arp-scan python3 python3-pip tcpdump ethtool nmap rtpflood traceroute && rm -rf /var/lib/apt/lists/*;

# move tcpdump from the default location to /usr/local
RUN mv /usr/sbin/tcpdump /usr/local/bin
# add the new location to the PATH in case it's not there
ENV PATH="/usr/local/bin:${PATH}"

RUN pip3 install --no-cache-dir cryptography notebook bs4 connexion[swagger-ui] flask

RUN git clone https://github.com/senisioi/scapy.git && cd scapy && python3 setup.py install

RUN apt-get update && apt-get install --no-install-recommends -y iputils-ping dnsutils && rm -rf /var/lib/apt/lists/*;