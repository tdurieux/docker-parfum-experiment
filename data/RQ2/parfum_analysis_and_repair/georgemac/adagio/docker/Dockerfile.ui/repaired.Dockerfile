FROM node:12.10 AS base

RUN mkdir /ui

ADD ./ui/package.json /ui/.
ADD ./ui/yarn.lock /ui/.
ADD ./ui/babel.config.js /ui/.
ADD ./ui/vue.config.js /ui/.

WORKDIR /ui

RUN yarn install && yarn cache clean;

ADD ./ui/src /ui/src
ADD ./ui/public /ui/public

ADD ./pkg/rpc/controlplane/service.swagger.json /pkg/rpc/controlplane/service.swagger.json

RUN yarn build && yarn cache clean;

FROM abiosoft/caddy

COPY --from=base /ui/dist /app

COPY ui/Caddyfile /etc/Caddyfile
