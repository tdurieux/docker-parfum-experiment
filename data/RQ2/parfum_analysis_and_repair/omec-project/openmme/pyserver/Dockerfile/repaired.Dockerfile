#
# Copyright 2020-present Open Networking Foundation
#
# SPDX-License-Identifier: Apache-2.0
#

FROM ubuntu:18.04

RUN apt update -y && apt install --no-install-recommends python3 python3-dev python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir flask
RUN pip3 install --no-cache-dir prometheus_client

WORKDIR /openmme
COPY ./monitor_client.py ./
COPY ./conf ./conf
