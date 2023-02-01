FROM adoptopenjdk/openjdk8:latest

RUN apt-get update && apt-get install --no-install-recommends -y wget unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG NEO4J_VERSION=4.0.11

RUN wget https://dist.neo4j.org/neo4j-community-${NEO4J_VERSION}-unix.tar.gz
RUN tar -xzf neo4j-community-${NEO4J_VERSION}-unix.tar.gz && rm neo4j-community-${NEO4J_VERSION}-unix.tar.gz
RUN mv neo4j-community-${NEO4J_VERSION} neo4j-community-installed
