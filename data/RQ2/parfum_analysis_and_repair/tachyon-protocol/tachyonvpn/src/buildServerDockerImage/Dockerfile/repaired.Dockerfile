FROM ubuntu:18.04

WORKDIR /usr/local/bin
RUN apt-get update
RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iproute2 && rm -rf /var/lib/apt/lists/*;
COPY server ./

CMD ["server"]
