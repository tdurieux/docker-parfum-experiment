FROM ubuntu:latest
WORKDIR /app
RUN sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y wget dnsutils vim curl net-tools iptables iputils-ping lsof iproute2 tcpdump && rm -rf /var/lib/apt/lists/*;
COPY ./kubevpn /usr/local/bin/kubevpn