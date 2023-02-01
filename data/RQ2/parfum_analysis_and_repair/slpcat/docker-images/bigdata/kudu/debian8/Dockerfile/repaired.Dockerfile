FROM debian:jessie

RUN apt-get update && apt-get -y --no-install-recommends install wget curl && \
cd /etc/apt/sources.list.d && \
 wget -qO - https://archive.cloudera.com/kudu/debian/jessie/amd64/kudu/archive.key | sudo apt-key add - && \
 wget https://archive.cloudera.com/kudu/debian/jessie/amd64/kudu/cloudera.list && \
apt-get update && \
apt-get -y dist-upgrade && \
 apt-get -y --no-install-recommends install kudu kudu-master kudu-tserver libkuduclient0 libkuduclient-dev && rm -rf /var/lib/apt/lists/*;

VOLUME /var/lib/kudu

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8050 8051 7050 7051
CMD ["help"]
