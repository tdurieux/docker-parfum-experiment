FROM mhart/alpine-node:15.4

RUN apk add --update --no-cache yarn py-pip g++ make && rm -rf /var/cache/apk

RUN mkdir -p /home/node/app

RUN addgroup -S node \
  && adduser -S -D -h /home/node node node \
  && chown -R node:node /home/node
USER node

WORKDIR /home/node/app

COPY package.json ./
COPY yarn.lock ./

RUN yarn --frozen-lockfile && yarn cache clean;

COPY --chown=node:node . .

EXPOSE 3000

CMD ["yarn", "start"]
