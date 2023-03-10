FROM node:10

ENV POLLING_INTERVAL=5000
ENV LOG_LEVEL=debug
ENV RPC=https://rpc.fusespark.io
ENV CONSENSUS_ADDRESS=0xC8c3a332f9e4CE6bfFFcf967026cB006Db2311c7
ENV BLOCK_REWARD_ADDRESS=0x52B9b9585e1b50DA5600f7dbD94E9fE68943162c

COPY ./ ./
RUN npm install --only=prod && npm cache clean --force;

CMD ["node", "index.js"]
