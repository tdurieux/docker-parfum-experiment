FROM node:10-buster

RUN mkdir -p /opt/node
WORKDIR /opt/node

# COPY eth-subscribe/node_modules node_modules
COPY eth-server/package.json package.json
RUN npm i && npm cache clean --force;

COPY mq mq
COPY eth-server/src src

CMD node src/subscribe ${wss} ${contract} ${mqServer} ${chainId}
# CMD sleep 36000