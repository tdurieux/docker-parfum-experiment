FROM debian:stable-slim

ARG APT_MIRROR=mirrors.ustc.edu.cn

ADD bin/agent /usr/bin/smartagent
ADD conf/client.conf /etc

ENV AGENT_ID="$IP"
ENV SERVER="127.0.0.1:13081"

ENV PATH="$PATH:/sbin"

RUN sed -i "s|deb.debian.org|$APT_MIRROR|g" /etc/apt/sources.list && \
    sed -i "s|security.debian.org|$APT_MIRROR|g" /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y sudo procps systemctl perl && \
    echo "root:root!"|chpasswd && \
    cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && rm -rf /var/lib/apt/lists/*;

CMD sed -i "s|^id.*$|id=$AGENT_ID|g" /etc/client.conf && \
    sed -i "s|^server.*$|server=$SERVER|g" /etc/client.conf && \
    /usr/bin/smartagent -conf /etc/client.conf