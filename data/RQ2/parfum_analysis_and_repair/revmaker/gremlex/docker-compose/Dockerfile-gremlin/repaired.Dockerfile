FROM ubuntu:artful

WORKDIR /srv

RUN apt-get update && apt-get install --no-install-recommends -y unzip wget openjdk-9-jdk && rm -rf /var/lib/apt/lists/*;

RUN wget https://archive.apache.org/dist/tinkerpop/3.3.1/apache-tinkerpop-gremlin-server-3.3.1-bin.zip

RUN unzip apache-tinkerpop-gremlin-server-3.3.1-bin.zip

WORKDIR /srv/apache-tinkerpop-gremlin-server-3.3.1

COPY gremlin-conf.yaml conf/gremlin-conf.yaml

EXPOSE 8182

ENTRYPOINT ["bin/gremlin-server.sh", "conf/gremlin-conf.yaml"]

