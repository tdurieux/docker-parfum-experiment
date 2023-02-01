FROM node:17-alpine

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

RUN apk add --no-cache git python3 build-base
RUN npm i -g pnpm && npm cache clean --force;

RUN apk add --no-cache git
RUN npm i -g pnpm && npm cache clean --force;

COPY package.json .
RUN NODE_ENV=development pnpm i

COPY . .
RUN NODE_ENV=development pnpm i
RUN pnpm build

CMD ["node", "build"]
