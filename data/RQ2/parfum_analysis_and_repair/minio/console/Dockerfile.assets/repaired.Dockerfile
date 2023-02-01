FROM node:17 as uilayer

WORKDIR /app

COPY ./portal-ui/package.json ./
COPY ./portal-ui/yarn.lock ./
RUN yarn install && yarn cache clean;

COPY ./portal-ui .

RUN yarn install && make build-static && yarn cache clean;

USER node
