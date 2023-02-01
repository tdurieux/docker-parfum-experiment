FROM node:16.11.0

COPY package.json package.json
RUN yarn && yarn cache clean;

COPY . .
RUN yarn build && yarn cache clean;

FROM node:16.11.0

WORKDIR /app

ENV NODE_ENV=production

COPY --from=0 package.json package.json
RUN yarn && yarn cache clean;

COPY --from=0 dist .

CMD ["node", "index.js"]