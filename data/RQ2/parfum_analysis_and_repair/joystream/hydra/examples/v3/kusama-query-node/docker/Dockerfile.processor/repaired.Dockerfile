FROM node:12-alpine

RUN mkdir -p /home/hydra-processor && chown -R node:node /home/hydra-processor

WORKDIR /home/hydra-processor

COPY --from=builder /home/hydra-builder/mappings/lib /home/hydra-processor/mappings/lib
COPY --from=builder /home/hydra-builder/mappings/node_modules /home/hydra-processor/mappings/node_modules
COPY --from=builder /home/hydra-builder/mappings/package.json /home/hydra-processor/mappings/package.json
COPY --from=builder /home/hydra-builder/node_modules /home/hydra-processor/node_modules

## FIXME: resolve typedefs.json from the root folder, this is a workaround
COPY --from=builder /home/hydra-builder/typedefs.json /home/hydra-processor/mappings/lib/mappings/generated/types

COPY --from=builder /home/hydra-builder/package.json .
COPY --from=builder /home/hydra-builder/yarn.lock .
COPY --from=builder /home/hydra-builder/manifest.yml .

RUN yarn --frozen-lockfile && yarn cache clean;

CMD ["yarn", "processor:start"]


