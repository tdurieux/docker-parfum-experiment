FROM ubuntu:16.04

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
COPY sources.list /etc/apt/sources.list
COPY ./webserver /webserver
WORKDIR /webserver

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y iptables && \
    apt-get install --no-install-recommends -y python3 && \
    apt-get install --no-install-recommends -y python3-pip && \
    pip3 install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple && rm -rf /var/lib/apt/lists/*;

EXPOSE 5000




