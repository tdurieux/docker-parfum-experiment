FROM ubuntu:16.04
ADD start.sh /
RUN apt-get update; apt-get install --no-install-recommends -y wget dnsutils apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN wget -O /etc/apt/sources.list.d/scylla.list https://repositories.scylladb.com/scylla/repo/5590ac9516d8a6fa58b1378c0d13b4ba/ubuntu/scylladb-2.0-xenial.list
RUN apt-get update; apt-get install --no-install-recommends -y scylla-server scylla-jmx scylla-tools --force-yes && rm -rf /var/lib/apt/lists/*;
RUN sed -i 's/listen_address:/#listen_address:/i' /etc/scylla/scylla.yaml
RUN sed -i 's/endpoint_snitch:/#endpoint_snitch:/i' /etc/scylla/scylla.yaml
RUN sed -i 's/rpc_address:/#rpc_address:/i' /etc/scylla/scylla.yaml
CMD bash /start.sh
