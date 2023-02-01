FROM ubuntu:20.04

RUN apt-get -qq update -y && apt-get -qq -y --no-install-recommends install wget jq ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/
COPY dist/docker/tecli .