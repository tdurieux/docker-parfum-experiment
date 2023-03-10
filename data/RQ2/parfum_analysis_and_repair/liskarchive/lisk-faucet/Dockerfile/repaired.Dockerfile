ARG NODEJS_VERSION=12
FROM node:$NODEJS_VERSION AS builder

COPY . /home/lisk/lisk-faucet/
RUN useradd lisk && \
    chown lisk:lisk -R /home/lisk
USER lisk
RUN cd /home/lisk/lisk-faucet && \
    npm install && npm cache clean --force;

FROM node:$NODEJS_VERSION-alpine

RUN adduser -D lisk
COPY --chown=lisk:lisk --from=builder /home/lisk/lisk-faucet /home/lisk/lisk-faucet

USER lisk
WORKDIR /home/lisk/lisk-faucet
CMD ["node", "app.js"]
