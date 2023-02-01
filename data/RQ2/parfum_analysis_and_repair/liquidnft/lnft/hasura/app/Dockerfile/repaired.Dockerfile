FROM node:17-alpine3.13

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV
ENV NODE_OPTIONS --openssl-legacy-provider

RUN apk add --no-cache git ffmpeg python3 build-base vips-dev
RUN npm i -g pnpm && npm cache clean --force;

WORKDIR /app
COPY package.json .
RUN pnpm install

COPY . .

CMD ["pnpm", "start"]
