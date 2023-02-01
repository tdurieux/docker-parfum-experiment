FROM ubuntu:20.04

MAINTAINER Sergiu Nisioi <sergiu.nisioi@fmi.unibuc.ro>

USER root

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git net-tools arp-scan python3 python3-pip tcpdump ethtool nmap rtpflood && rm -rf /var/lib/apt/lists/*;

# move tcpdump from the default location to /usr/local
RUN mv /usr/sbin/tcpdump /usr/local/bin
# add the new location to the PATH in case it's not there
ENV PATH="/usr/local/bin:${PATH}"

RUN apt-get update && apt-get install --no-install-recommends -y graphviz imagemagick texlive && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir cryptography matplotlib graphviz vpython PyX geoip2 scipy notebook

RUN wget https://web.archive.org/web/20191227182209/https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
RUN tar -xvf GeoLite2-City.tar.gz && mv GeoLite2-City_20191224/GeoLite2-City.mmdb /GeoLite2-City.mmdb && rm GeoLite2-City.tar.gz

RUN apt-get update && apt-get install --no-install-recommends -y libgeos-* proj-* libproj-dev libgeos++-dev python3-cartopy python3-tk && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --pre scapy[complete]

#RUN git clone https://github.com/senisioi/scapy.git && cd scapy && python3 setup.py install

RUN apt-get update && apt-get install --no-install-recommends -y iputils-ping dnsutils && rm -rf /var/lib/apt/lists/*;