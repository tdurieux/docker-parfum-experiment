FROM golang:stretch
ENV maintainer=ztao8607@gmail.com
COPY stretch.repo /etc/apt/sources.list
RUN apt-get update && \
    apt-get install --no-install-recommends -y libpcap-dev && rm -rf /var/lib/apt/lists/*;