# docker build -t clickhouse/mysql-java-client .
# MySQL Java client docker container

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common build-essential openjdk-8-jdk libmysql-java curl && rm -rf /var/lib/apt/lists/*;

RUN rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/debconf \
        /tmp/* \
RUN apt-get clean

ARG ver=5.1.46
RUN curl -f -L -o /mysql-connector-java-${ver}.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/${ver}/mysql-connector-java-${ver}.jar
ENV CLASSPATH=$CLASSPATH:/mysql-connector-java-${ver}.jar

WORKDIR /jdbc
COPY Test.java Test.java
RUN javac Test.java
