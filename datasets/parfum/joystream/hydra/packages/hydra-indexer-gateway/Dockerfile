FROM node:14-alpine 

RUN mkdir -p /home/hydra && chown -R node:node /home/hydra

WORKDIR /home/hydra

COPY --from=hydra-builder:latest --chown=node:node /home/hydra/packages/bn-typeorm/lib ./packages/bn-typeorm/lib
COPY --from=hydra-builder:latest --chown=node:node /home/hydra/packages/bn-typeorm/*.json ./packages/bn-typeorm/

COPY --from=hydra-builder:latest --chown=node:node /home/hydra/packages/hydra-common/lib ./packages/hydra-common/lib
COPY --from=hydra-builder:latest --chown=node:node /home/hydra/packages/hydra-common/*.json ./packages/hydra-common/

COPY --from=hydra-builder:latest --chown=node:node /home/hydra/packages/hydra-db-utils/lib ./packages/hydra-db-utils/lib
COPY --from=hydra-builder:latest --chown=node:node /home/hydra/packages/hydra-db-utils/*.json ./packages/hydra-db-utils/

COPY --from=hydra-builder:latest --chown=node:node /home/hydra/package.json .
COPY --from=hydra-builder:latest --chown=node:node /home/hydra/yarn.lock .

COPY --chown=node:node src /home/hydra/packages/hydra-indexer-gateway/src
COPY --chown=node:node generated /home/hydra/packages/hydra-indexer-gateway/generated
COPY --chown=node:node env.yml /home/hydra/packages/hydra-indexer-gateway
COPY --chown=node:node *.json /home/hydra/packages/hydra-indexer-gateway/
COPY --chown=node:node *.js /home/hydra/packages/hydra-indexer-gateway/


RUN yarn --frozen-lockfile --non-interactive 
RUN yarn workspace @joystream/hydra-indexer-gateway build

WORKDIR /home/hydra/packages/hydra-indexer-gateway

CMD ["yarn", "start:prod"]
