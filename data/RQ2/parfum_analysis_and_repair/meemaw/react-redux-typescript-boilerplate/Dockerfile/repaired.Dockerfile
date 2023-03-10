FROM node:13-alpine

RUN apk add --no-cache bash

ADD yarn.lock /yarn.lock
ADD package.json /package.json

ENV NODE_PATH=/node_modules
ENV PATH=$PATH:/node_modules/.bin

WORKDIR /app
ADD ./src /app/src
ADD ./*.json /app/
ADD ./yarn.lock /app
ADD ./public /app/public
ADD ./scripts /app/scripts
RUN yarn install --frozen-lockfile --production --ignore-scripts --prefer-offline && yarn cache clean;

EXPOSE 3000
EXPOSE 35729

ENTRYPOINT ["/bin/bash", "/app/scripts/run.sh"]
CMD ["start"]
