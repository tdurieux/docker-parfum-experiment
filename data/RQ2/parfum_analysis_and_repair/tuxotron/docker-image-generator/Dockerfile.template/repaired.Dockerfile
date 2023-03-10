FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt
ENV LANG en_US.utf8

RUN TZ=America/New_York && \
    apt update && \
    apt install --no-install-recommends -y software-properties-common git curl p7zip-full wget whois locales python3 python3-pip upx psmisc iproute2 && \
    add-apt-repository -y ppa:longsleep/golang-backports && \
    apt update && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

RUN {{ with .List }} {{ range . }} {{ . }} && \ {{ printf "\n" }} {{ end }} {{ end }} rm -rf /var/lib/apt/lists/*
