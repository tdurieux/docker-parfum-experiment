FROM ubuntu:18.04
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y dnsmasq dnsutils python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir doh-proxy
WORKDIR /usr/src/app
COPY dnsmasq.conf .
COPY run.sh .
CMD ["./run.sh"]
