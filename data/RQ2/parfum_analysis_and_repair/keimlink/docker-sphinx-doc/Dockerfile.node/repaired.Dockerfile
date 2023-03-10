FROM node:8.9.4-alpine

COPY bin/docker-entrypoint-node.sh /usr/local/bin/docker-entrypoint.sh

USER 1000

WORKDIR /home/node

COPY --chown=1000:1000 package.json yarn.lock ./

RUN yarn install && rm -fr .cache/yarn && yarn cache clean;

WORKDIR /home/node/src

VOLUME /home/node/src

ENTRYPOINT ["docker-entrypoint.sh"]
