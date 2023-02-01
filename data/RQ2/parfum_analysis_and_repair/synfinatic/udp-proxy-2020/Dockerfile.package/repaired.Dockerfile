FROM ubuntu:20.04 AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y git golang && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /root/dist && \
    cd /root && git clone https://github.com/kentik/pkg.git && \
    cd pkg && go build . && mv pkg /usr/bin/pkg

FROM base as builder
ENV VERSION=1.0.0
RUN mkdir -p /root/startup-scripts/systemd /root/package
COPY package.sh /root
COPY startup-scripts/systemd/* /root/startup-scripts/systemd/
COPY package/* /root/package/
CMD /root/package.sh
