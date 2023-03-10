FROM mhart/alpine-node:10.1

# set `--build-arg` in docker build
ARG REGISTRY=https://registry.yarnpkg.com

COPY package.json /app/
COPY bin /app/bin

WORKDIR /app

RUN yarn config set registry $REGISTRY && yarn && yarn cache clean;

ADD . /app

EXPOSE 3000

CMD yarn dev
