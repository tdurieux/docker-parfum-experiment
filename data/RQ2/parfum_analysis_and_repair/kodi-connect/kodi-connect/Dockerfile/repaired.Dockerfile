ARG GIT_HASH

########################################
FROM node:12.14 as builder

ENV HOME=/home/node
WORKDIR $HOME/app

RUN ln -sf /usr/share/zoneinfo/Europe/Bratislava /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata && \
  apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

COPY package.json yarn.lock $HOME/app/
RUN yarn install && yarn cache clean;

COPY . $HOME/app
RUN yarn run build && yarn cache clean;

########################################
FROM node:12.14-slim as prod

LABEL githash=${GIT_HASH}

ENV GIT_HASH=${GIT_HASH}
ENV NODE_ENV=production
ENV HOME=/home/node
WORKDIR $HOME/app

COPY package.json yarn.lock $HOME/app/
RUN yarn install && yarn cache clean;

COPY --from=builder $HOME/app/build $HOME/app/build

RUN chown -R node:node $HOME/app

USER node
CMD ["yarn", "start"]
