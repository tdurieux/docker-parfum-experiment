FROM ethereum/solc:0.6.4-alpine

RUN apk add --d --no-cache ca-certificates npm nodejs bash alpine-sdk git

RUN git clone https://github.com/binance-chain/canonical-upgradeable-bep20.git /usr/app/canonical-upgradeable-bep20

WORKDIR /usr/app/canonical-upgradeable-bep20
COPY docker/truffle-config.js /usr/app/canonical-upgradeable-bep20

RUN npm install -g --unsafe-perm truffle@v5.1.14 && npm cache clean --force;
RUN npm install && npm cache clean --force;

ENTRYPOINT [ "/bin/bash" ]
