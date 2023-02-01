FROM node:current-alpine

COPY package.json package.json
RUN yarn && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

FROM node:current-alpine

ENV NODE_ENV=production

COPY package.json package.json
RUN yarn && yarn cache clean;

COPY --from=0 dist .

CMD ["node", "index"]