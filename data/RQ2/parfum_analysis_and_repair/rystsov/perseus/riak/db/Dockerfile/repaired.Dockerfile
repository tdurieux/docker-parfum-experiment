FROM ubuntu:16.04
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y vim lsof supervisor iptables iputils-ping tmux less curl && rm -rf /var/lib/apt/lists/*;
RUN mkdir /riak
WORKDIR /riak
RUN /bin/bash -c "curl -s https://packagecloud.io/install/repositories/basho/riak/script.deb.sh | bash"
RUN apt-get install --no-install-recommends -y riak=2.2.3-1 && rm -rf /var/lib/apt/lists/*;
COPY run-riak.sh /riak/run-riak.sh
COPY join-riak1.sh /riak/join-riak1.sh
COPY isolate.sh /riak/isolate.sh
COPY rejoin.sh /riak/rejoin.sh
COPY riak.conf /etc/supervisor/conf.d/riak.conf
CMD /usr/bin/supervisord -n