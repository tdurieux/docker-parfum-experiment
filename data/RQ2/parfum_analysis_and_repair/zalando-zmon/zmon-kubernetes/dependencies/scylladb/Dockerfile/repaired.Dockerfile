FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget vim && rm -rf /var/lib/apt/lists/*;
RUN wget -O /etc/apt/sources.list.d/scylla.list https://downloads.scylladb.com/deb/ubuntu/scylla-1.3-xenial.list
RUN apt-get update && apt-get install --no-install-recommends -y scylla-server scylla-jmx scylla-tools --force-yes && rm -rf /var/lib/apt/lists/*;

USER root
COPY start-scylla /start-scylla
RUN  chown -R scylla:scylla /etc/scylla
RUN  chown -R scylla:scylla /etc/scylla.d
RUN  chown -R scylla:scylla /start-scylla

USER scylla
EXPOSE 10000 9042 9160 7000 7001
VOLUME /var/lib/scylla

CMD /start-scylla
