# updated and modified from https://github.com/havnfun/docker-hapi-fhir-cli
FROM adoptopenjdk/openjdk8

RUN apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*

RUN mkdir /hapi-fhir && mkdir /data && ln -s /data /hapi-fhir/target && cd /hapi-fhir

WORKDIR /hapi-fhir
VOLUME /data

RUN wget https://github.com/hapifhir/hapi-fhir/releases/download/v5.6.0/hapi-fhir-5.6.0-cli.tar.bz2 \
    && tar -xf hapi-fhir-5.6.0-cli.tar.bz2 && rm hapi-fhir-5.6.0-cli.tar.bz2

# RUN apt-get update && apt-get install -y wget