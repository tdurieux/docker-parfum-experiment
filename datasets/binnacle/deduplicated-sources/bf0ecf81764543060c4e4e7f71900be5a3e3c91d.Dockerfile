# Copyright IBM Corp, All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
FROM busybox as builder
ENV FABRIC_VERSION_1_0 1.0.5
RUN cd /tmp && ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}') && \
    echo $ARCH &&wget -c https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/${ARCH}-${FABRIC_VERSION_1_0}/hyperledger-fabric-${ARCH}-${FABRIC_VERSION_1_0}.tar.gz && \
    mkdir fabric-1.0 && tar -zxvf hyperledger-fabric-${ARCH}-${FABRIC_VERSION_1_0}.tar.gz -C fabric-1.0
ENV FABRIC_VERSION_1_2 1.2.0
RUN cd /tmp && ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}') && \
    echo $ARCH &&wget -c https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/${ARCH}-${FABRIC_VERSION_1_2}/hyperledger-fabric-${ARCH}-${FABRIC_VERSION_1_2}.tar.gz && \
    mkdir fabric-1.2 && tar -zxvf hyperledger-fabric-${ARCH}-${FABRIC_VERSION_1_2}.tar.gz -C fabric-1.2
RUN cd /tmp && wget -c https://github.com/hyperledger/cello/archive/v0.9.0.zip && unzip v0.9.0.zip && mv cello-0.9.0 cello

FROM node:8.9
MAINTAINER haitao yue "hightall@me.com"
COPY --from=builder /tmp/cello/user-dashboard/src/package.json /
COPY --from=builder /tmp/cello/user-dashboard/src/yarn.lock /
COPY --from=builder /tmp/cello/user-dashboard/src/packages /packages
COPY --from=builder /tmp/cello/user-dashboard/src /var/www
COPY --from=builder /tmp/cello/user-dashboard/fabric/fabric-1.0 /etc/hyperledger/fabric-1.0
COPY --from=builder /tmp/cello/user-dashboard/fabric/fabric-1.2 /etc/hyperledger/fabric-1.2
COPY --from=builder /tmp/cello/user-dashboard/src/app/lib/fabric/fixtures/channel/v1.2/crypto-config /etc/hyperledger/fabric-1.2/crypto-config
RUN cd / && yarn install -g --verbose
RUN cd /packages/fabric-1.0 && yarn install
RUN cd /packages/fabric-1.2 && yarn install
ENV PATH ${PATH}:/node_modules/.bin
RUN cd /var/www && ln -sf /node_modules . && npm run build
WORKDIR /var/www
EXPOSE 8081

COPY --from=builder /tmp/fabric-1.0/bin/configtxgen /usr/local/bin/fabric-1.0/configtxgen
COPY --from=builder /tmp/fabric-1.2/bin/configtxgen /usr/local/bin/fabric-1.2/configtxgen
ENV FABRIC_CFG_PATH /etc/hyperledger/fabric-1.0
ENV MONGO_PORT 27017

RUN sed -i 's/.\/ecdsa\/key.js/fabric-client\/lib\/impl\/ecdsa\/key.js/g' /packages/fabric-1.2/node_modules/fabric-ca-client/lib/impl/CryptoSuite_ECDSA_AES.js

CMD ln -sf /node_modules . && npm run start
