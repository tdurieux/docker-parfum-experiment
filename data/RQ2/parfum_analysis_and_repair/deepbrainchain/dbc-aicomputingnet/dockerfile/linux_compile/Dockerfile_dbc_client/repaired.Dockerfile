# dbc linux client
FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends --yes \
    vim \
    net-tools \
    wget \
    tar && rm -rf /var/lib/apt/lists/*;


WORKDIR /root

ADD http://116.85.24.172:20444/static/dbc_client_linux.tar.gz /root

RUN tar -xvzf /root/dbc_client_linux.tar.gz && rm /root/dbc_client_linux.tar.gz

WORKDIR /root/dbc_client_linux

CMD ["/bin/bash"]