FROM node:14 AS build

ARG TAG
RUN git clone --depth=1 --branch ${TAG} https://github.com/baking-bad/bcd.git /bcd

WORKDIR /bcd
RUN yarn && yarn cache clean;

COPY build/sandbox/env.production /bcd/.env.production
RUN export NODE_OPTIONS=--openssl-legacy-provider
RUN yarn build && yarn cache clean;

FROM nginx:latest AS release
COPY build/sandbox/default.conf /etc/nginx/conf.d/default.conf
WORKDIR /usr/share/nginx/html/
COPY --from=build /bcd/dist ./