FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget supervisor iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /tidb
WORKDIR /tidb
RUN wget https://download.pingcap.org/tidb-latest-linux-amd64.tar.gz
RUN tar -xzf tidb-latest-linux-amd64.tar.gz && rm tidb-latest-linux-amd64.tar.gz
RUN rm tidb-latest-linux-amd64.tar.gz
COPY run-pd.sh /tidb/run-pd.sh
COPY run-kv.sh /tidb/run-kv.sh
COPY run-db.sh /tidb/run-db.sh
COPY isolate.sh /tidb/isolate.sh
COPY rejoin.sh /tidb/rejoin.sh
COPY tidb.conf /etc/supervisor/conf.d/tidb.conf
CMD /usr/bin/supervisord -n
