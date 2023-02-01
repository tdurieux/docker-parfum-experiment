FROM node:14.15.4-alpine

ENV ZKSYNC_HOME=/app/src/zksync

ENV PATH=$ZKSYNC_HOME/bin:$PATH

WORKDIR /app

RUN apk add --no-cache git curl postgresql

COPY . .

RUN cd src/zksync/sdk/zksync.js &&\
    yarn && \
    yarn build && yarn cache clean;

RUN yarn &&\
    yarn build &&\
    mkdir src/zksync/contracts/build && \
    cp build/* src/zksync/contracts/build/ && yarn cache clean;

RUN zk

ENTRYPOINT sh scripts/wait_prover.sh yarn integration
