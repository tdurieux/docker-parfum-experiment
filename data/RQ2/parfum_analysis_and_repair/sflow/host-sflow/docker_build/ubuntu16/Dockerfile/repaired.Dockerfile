FROM ubuntu:16.04
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      git-all \
      libpcap-dev \
      libvirt-dev \
      libnfnetlink-dev \
      libxml2-dev \
      libssl-dev \
      libdbus-1-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /packages && chown 777 /packages
COPY build_hsflowd /root/build_hsflowd
ENTRYPOINT ["/root/build_hsflowd"]
