FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-8-jdk-headless && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

COPY src/ /work

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN BUILD=build make
