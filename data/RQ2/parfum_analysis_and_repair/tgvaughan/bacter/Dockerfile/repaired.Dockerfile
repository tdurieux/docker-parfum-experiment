# Dockerfile to build container for unit testing

FROM openjdk:8

RUN apt-get update && apt-get install --no-install-recommends -y git ant && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

ADD . ./

ENTRYPOINT ant test
