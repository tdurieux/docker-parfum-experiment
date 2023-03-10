# TODO
# Install connector as yarn package like in @hyperledger/cactus-plugin-ledger-connector-besu

FROM node:14

WORKDIR /root/cactus/

COPY ./dist/yarn.lock ./package.json ./
RUN yarn install --production --ignore-engines --non-interactive --cache-folder ./.yarnCache; yarn cache clean; rm -rf ./.yarnCache

COPY ./dist ./dist/

EXPOSE 5040
VOLUME ["/etc/cactus/"]
CMD ["npm", "run", "start"]
