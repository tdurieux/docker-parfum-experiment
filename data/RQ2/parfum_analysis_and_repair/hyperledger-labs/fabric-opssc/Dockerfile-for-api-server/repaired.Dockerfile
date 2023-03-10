# Copyright 2019-2021 Hitachi, Ltd., Hitachi America, Ltd. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0

FROM node:10

ARG FABRIC_VERSION

ADD opssc-api-server/src opt/app/src
ADD common /opt/common
# Allow npm to run prepare script as root
RUN cd /opt/common/src; npm --unsafe-perm install && npm cache clean --force;
RUN cd /opt/app/src; npm --unsafe-perm install && npm cache clean --force;

# Add fabric binaries
RUN cd /
RUN wget https://github.com/hyperledger/fabric/releases/download/v${FABRIC_VERSION}/hyperledger-fabric-linux-amd64-${FABRIC_VERSION}.tar.gz
RUN tar -xzf hyperledger-fabric-linux-amd64-${FABRIC_VERSION}.tar.gz && rm hyperledger-fabric-linux-amd64-${FABRIC_VERSION}.tar.gz

# Add fabric-configtx-cli
ADD configtx-cli/bin/fabric-configtx-cli /usr/local/bin

ENTRYPOINT cd /opt/app/src; npm start


