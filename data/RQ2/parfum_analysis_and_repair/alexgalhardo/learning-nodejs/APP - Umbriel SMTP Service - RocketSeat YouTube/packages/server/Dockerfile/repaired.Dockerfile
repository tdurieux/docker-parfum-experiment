FROM node:12-alpine AS builder

RUN mkdir -p /home/node/build/node_modules && chown -R node:node /home/node/build

WORKDIR /home/node/build

COPY --chown=node:node package.json yarn.* ./

USER node

RUN yarn && yarn cache clean;

COPY --chown=node:node . .

RUN yarn build && yarn cache clean;


FROM node:12-alpine

RUN mkdir -p /home/node/api/node_modules && chown -R node:node /home/node/api

WORKDIR /home/node/api

RUN yarn global add pm2 && yarn cache clean;

USER node

COPY --chown=node:node --from=builder /home/node/build/node_modules ./node_modules
COPY --chown=node:node --from=builder /home/node/build/process.yml .
COPY --chown=node:node --from=builder /home/node/build/dist .

EXPOSE 3333

CMD ["pm2-runtime", "process.yml"]