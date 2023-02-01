FROM ubuntu:16.04

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
COPY sources.list /etc/apt/sources.list
COPY ./server /server
WORKDIR /server

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y iptables && \
    apt-get install --no-install-recommends -y python3 && \
    apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;









