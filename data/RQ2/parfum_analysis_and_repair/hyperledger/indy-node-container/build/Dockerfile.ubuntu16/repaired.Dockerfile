# This container is to run indy-node.
# This file is part of https://github.com/hyperledger/indy-node-container .
# Copyright 2021-2022 by all people listed in https://github.com/hyperledger/indy-node-container/blob/main/NOTICE , see
# https://github.com/hyperledger/indy-node-container/blob/main/LICENSE for the license information.
#
# version: 1.0+2021-09-02

FROM ubuntu:16.04

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CE7709D068DB5E88
RUN bash -c 'echo "deb https://repo.sovrin.org/deb xenial stable" >> /etc/apt/sources.list'
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    indy-node=1.12.4 \
    && rm -rf /var/lib/apt/lists/*

COPY init_and_run.sh ./

CMD ["./init_and_run.sh"]
