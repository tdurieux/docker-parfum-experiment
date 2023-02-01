FROM openjdk:8-jdk
LABEL maintainer="Markus Mayer <widemeadows@gmail.com>"

ARG version=0.3.0
ARG hadoop=hadoop2

RUN apt-get update && \
    apt-get install -y wget unzip htop && \
    mkdir /workspace && \
    cd /workspace && \
    wget https://github.com/JanusGraph/janusgraph/releases/download/v$version/janusgraph-$version-$hadoop.zip && \
    unzip janusgraph-$version-$hadoop.zip && \
    rm janusgraph-$version-$hadoop.zip && \
    mv janusgraph-* janusgraph

WORKDIR /workspace/janusgraph

# This next step might take a while.
RUN bin/gremlin-server.sh -i org.apache.tinkerpop gremlin-python 3.3.3

COPY janusgraph/gremlin-server.yaml /workspace/janusgraph/conf/gremlin-server/gremlin-server.yaml
COPY janusgraph/janusgraph.properties /workspace/janusgraph/janusgraph.properties

# Example graphs and data
COPY janusgraph/empty-sample.groovy /workspace/janusgraph/scripts/empty-sample.groovy
COPY janusgraph/data/*.graphml /workspace/janusgraph/data/

COPY janusgraph/run.sh /workspace/janusgraph
CMD ["/bin/bash", "-e", "/workspace/janusgraph/run.sh"]
