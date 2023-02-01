FROM ubuntu:18.04

RUN apt-get update && apt-get -y --no-install-recommends install zookeeper && rm -rf /var/lib/apt/lists/*;

EXPOSE 2181
CMD /usr/share/zookeeper/bin/zkServer.sh start-foreground
