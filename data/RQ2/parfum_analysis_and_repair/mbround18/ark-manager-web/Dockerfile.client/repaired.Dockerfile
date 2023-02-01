FROM registry.hub.docker.com/library/node:lts as ClientBuild
WORKDIR /apps/client
COPY ./client/package.json ./yarn.lock ./.yarnrc.yml ./
COPY ./.yarn/releases ./.yarn/releases
RUN yarn install && yarn cache clean;
COPY ./client  ./
RUN NODE_ENV=production \
    yarn workspace client build && yarn cache clean;


FROM registry.hub.docker.com/library/caddy:latest
COPY --from=ClientBuild /apps/dist /apps/client
COPY ./config/Caddyfile /etc/caddy/Caddyfile
