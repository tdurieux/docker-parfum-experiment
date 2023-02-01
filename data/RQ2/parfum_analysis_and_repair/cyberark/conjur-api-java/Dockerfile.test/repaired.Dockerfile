FROM openjdk:17-jdk-bullseye

MAINTAINER Conjur Inc

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --no-install-recommends -y vim wget curl git maven && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /conjurinc/api-java

WORKDIR /conjurinc/api-java

COPY . /conjurinc/api-java

RUN mvn compile