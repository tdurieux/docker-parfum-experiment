FROM node:alpine

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

RUN apk add --no-cache git
RUN apk add --no-cache --update npm
RUN npm i -g pnpm && npm cache clean --force;

COPY . /app
WORKDIR /app

RUN pnpm i

CMD ["pnpm", "start"]
