FROM node:9 as build

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN yarn && yarn cache clean;
COPY . /usr/src/app

FROM mhart/alpine-node:base-9
ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV:-development}
WORKDIR /usr/src/app
COPY --from=build /usr/src/app .
ENTRYPOINT [ "node", "main.js" ]
