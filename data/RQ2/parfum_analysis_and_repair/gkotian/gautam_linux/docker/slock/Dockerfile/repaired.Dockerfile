FROM ubuntu:16.04

RUN apt-get update && apt-get -y --no-install-recommends install \
    suckless-tools && rm -rf /var/lib/apt/lists/*;

ENV IN_DOCKER_CONTAINER True
