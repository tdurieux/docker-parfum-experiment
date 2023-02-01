FROM node:8-alpine as builder

COPY package.json package-lock.json /app/
WORKDIR /app

RUN npm install

COPY . /app

FROM node:8-alpine

ENV APP_PORT=3000
ENV AXIOS_DISABLE_PROXY=true
EXPOSE ${APP_PORT}

RUN mkdir /app && chown node:node /app
COPY --from=builder --chown=node:node /app /app
WORKDIR /app

USER node

CMD [ "npm", "start" ]