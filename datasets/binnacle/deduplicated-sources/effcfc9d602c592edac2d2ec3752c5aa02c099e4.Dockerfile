# syntax = docker/dockerfile:experimental

FROM node:alpine as builder

WORKDIR /app

COPY package.json /app/

RUN --mount=type=cache,target=/app/node_modules,id=my_app_npm_module,sharing=locked \
    --mount=type=cache,target=/root/.npm,id=npm_cache \
        npm i --registry=https://registry.npm.taobao.org

COPY src /app/src

RUN --mount=type=cache,target=/app/node_modules,id=my_app_npm_module,sharing=locked \
# --mount=type=cache,target=/app/dist,id=my_app_dist,sharing=locked \
        npm run build

FROM nginx:alpine

# COPY --from=builder /app/dist /app/dist

# 为了更直观的说明 from 和 source 指令，这里使用 RUN 指令
RUN --mount=type=cache,target=/tmp/dist,from=builder,source=/app/dist \
    # --mount=type=cache,target/tmp/dist,from=my_app_dist,sharing=locked \
    mkdir -p /app/dist && cp -r /tmp/dist/* /app/dist

RUN --mount=type=bind,from=php:alpine,source=/usr/local/bin/docker-php-entrypoint,target=/docker-php-entrypoint \
        cat /docker-php-entrypoint

RUN --mount=type=tmpfs,target=/temp \
        mount | grep /temp

RUN --mount=type=secret,id=aws,target=/root/.aws/credentials \
        cat /root/.aws/credentials

# docker build -t test --secret id=aws,src=$PWD/aws.txt --progress=plain -f Dockerfile.buildkit .
