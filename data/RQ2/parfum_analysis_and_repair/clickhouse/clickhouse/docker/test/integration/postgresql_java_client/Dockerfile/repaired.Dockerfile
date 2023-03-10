# docker build -t clickhouse/postgresql-java-client .
# PostgreSQL Java client docker container

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common build-essential openjdk-8-jdk curl && rm -rf /var/lib/apt/lists/*;

RUN rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/debconf \
        /tmp/* \
RUN apt-get clean

ARG ver=42.2.12
RUN curl -f -L -o /postgresql-java-${ver}.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/${ver}/postgresql-${ver}.jar
ENV CLASSPATH=$CLASSPATH:/postgresql-java-${ver}.jar

WORKDIR /jdbc
COPY Test.java Test.java
RUN javac Test.java
