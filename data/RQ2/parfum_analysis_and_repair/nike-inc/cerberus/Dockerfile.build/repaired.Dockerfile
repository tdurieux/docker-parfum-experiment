# This docker image is for building the Cerberus artifacts, NOT for running the artifacts.

FROM ubuntu:bionic

RUN apt -y update && apt install --no-install-recommends -y curl jq git openssh-client bash openjdk-11-jdk python make gcc build-essential g++ && rm -rf /var/lib/apt/lists/*;
RUN apt -y upgrade

