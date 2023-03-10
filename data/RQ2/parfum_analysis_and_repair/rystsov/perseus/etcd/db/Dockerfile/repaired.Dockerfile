FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget supervisor iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /etcd
WORKDIR /etcd
RUN wget https://github.com/coreos/etcd/releases/download/v3.2.13/etcd-v3.2.13-linux-amd64.tar.gz
RUN tar -xzvf etcd-v3.2.13-linux-amd64.tar.gz && rm etcd-v3.2.13-linux-amd64.tar.gz
RUN rm etcd-v3.2.13-linux-amd64.tar.gz
COPY run-etcd.sh /etcd/run-etcd.sh
COPY isolate.sh /etcd/isolate.sh
COPY rejoin.sh /etcd/rejoin.sh
COPY etcd.conf /etc/supervisor/conf.d/etcd.conf
CMD /usr/bin/supervisord -n
