FROM node:16-alpine

WORKDIR /usr/src/app

COPY . .

# do not build modules for the core image
RUN node build-scripts/build-core-only.mjs

RUN yarn install && yarn cache clean;
RUN yarn build && yarn cache clean;

CMD yarn start
