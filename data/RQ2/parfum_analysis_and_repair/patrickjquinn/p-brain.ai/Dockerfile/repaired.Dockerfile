FROM node:12-alpine

EXPOSE 4567

WORKDIR /app
COPY . /app

RUN yarn --frozen-lockfile && yarn cache clean;
RUN yarn lint && yarn cache clean;
RUN yarn test && yarn cache clean;

RUN yarn --prod --frozen-lockfile && yarn cache clean;

ENTRYPOINT [ "/usr/local/bin/node", "server.js" ]
