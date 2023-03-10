FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget supervisor iptables unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /consul
WORKDIR /consul
RUN wget https://releases.hashicorp.com/consul/1.0.2/consul_1.0.2_linux_amd64.zip
RUN unzip consul_1.0.2_linux_amd64.zip
RUN rm consul_1.0.2_linux_amd64.zip
COPY run-consul.sh /consul/run-consul.sh
COPY isolate.sh /consul/isolate.sh
COPY rejoin.sh /consul/rejoin.sh
COPY consul.conf /etc/supervisor/conf.d/consul.conf
CMD /usr/bin/supervisord -n
