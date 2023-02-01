FROM node:9.3.0-alpine

EXPOSE 8080

ENV PORT 8080
ENV NODE_ENV production

RUN apk add --no-cache --update \
    python

RUN npm i -g pm2 --quiet && npm cache clean --force;

COPY package.json /tmp/package.json
COPY yarn.lock /tmp/yarn.lock

RUN yarn --version && node --version && npm --version

RUN cd /tmp && ls -la && yarn install --no-progress --frozen-lockfile || { exit 1; } && mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/ && yarn cache clean;

WORKDIR /opt/app

COPY . /opt/app

RUN yarn build

RUN rm -rf ./app/client \
	rm -rf ./app/common \
	rm -rf ./node_modules/webpack

# Clear deps and caches
RUN apk --purge del python && rm -rf /var/cache/apk/*

CMD pm2 start --log-type json --no-daemon static/server.js
