# TODO
# Install connector as yarn package like in @hyperledger/cactus-plugin-ledger-connector-besu

FROM node:12

WORKDIR /root/cactus/

COPY ./dist ./dist/
COPY ./dist/yarn.lock ./package.json ./
RUN yarn install --production --frozen-lockfile --non-interactive --cache-folder ./.yarnCache; yarn cache clean; rm -rf ./.yarnCache

EXPOSE 5050
CMD [ "npm", "run", "start" ]
