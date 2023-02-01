# Copyright 2019 VMware, all rights reserved.
# This software is released under MIT license.
# The full license information can be found in LICENSE in the root directory of this project.

FROM ubuntu:18.04
RUN apt-get update && apt-get -y --no-install-recommends install \
   git \
   sudo && rm -rf /var/lib/apt/lists/*;
# Using Solidity 0.5.2 because it is the latest, and we need to pin
# to a release.  Reference:
# https://solidity.readthedocs.io/en/v0.5.2/installing-solidity.html
RUN git clone --recursive https://github.com/ethereum/solidity.git
WORKDIR /solidity
RUN git submodule update --init --recursive
RUN git checkout 1df8f40cd2fd7b47698d847907b8ca7b47eb488d
RUN ./scripts/install_deps.sh
RUN ./scripts/build.sh

WORKDIR /source
COPY . /source
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -yq \
    && apt-get install --no-install-recommends curl gnupg -yq \
    && curl -f -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install --no-install-recommends nodejs -yq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN echo | add-apt-repository ppa:ethereum/ethereum
RUN apt-get update -y
RUN echo | npm install web3@0.20.1 && npm cache clean --force;
RUN npm install --save httpheaderprovider && npm cache clean --force;
RUN npm install --global mocha && npm cache clean --force;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
