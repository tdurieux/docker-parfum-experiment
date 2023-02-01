FROM openjdk:11-jdk-slim-buster
LABEL maintainer="Ryota Egusa <egusa.ryota@gmail.com>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends time sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN sh -c 'echo 127.0.1.1 $(hostname) >> /etc/hosts'

RUN mkdir /tmp/koj-workspace && chmod 777 /tmp/koj-workspace
