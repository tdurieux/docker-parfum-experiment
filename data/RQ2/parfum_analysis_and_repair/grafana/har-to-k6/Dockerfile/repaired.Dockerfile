FROM node:12-slim

WORKDIR /converter

COPY . .

RUN yarn && yarn cache clean;
RUN yarn bundle && yarn cache clean;

ENTRYPOINT ["node", "bin/har-to-k6.js"]
