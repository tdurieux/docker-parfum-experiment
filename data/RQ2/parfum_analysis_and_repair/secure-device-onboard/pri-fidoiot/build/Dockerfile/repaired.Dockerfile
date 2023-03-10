# Copyright 2020 Intel Corporation
# SPDX-License-Identifier: Apache 2.0

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean && apt-get -y update && apt-get -y upgrade

RUN apt-get install --no-install-recommends -y openjdk-11-jdk maven git && rm -rf /var/lib/apt/lists/*;

# Create a user 'fdouser'. If the user name is updated, please update the same in docker-compose.yaml.
RUN useradd -ms /bin/bash fdouser
RUN mkdir -p /home/fdouser/pri-fidoiot/ ; chown -R fdouser:fdouser /home/fdouser/pri-fidoiot/
RUN mkdir -p /home/fdouser/.m2/; chown -R fdouser:fdouser /home/fdouser/.m2
USER fdouser

WORKDIR /home/fdouser/pri-fidoiot/
ENTRYPOINT ./build/build.sh
