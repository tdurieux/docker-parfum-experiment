FROM node:17-alpine

ENV NODE_ENV staging

RUN apk add --no-cache git python3
RUN npm i -g pnpm && npm cache clean --force;

WORKDIR /app

COPY package.json .
RUN NODE_ENV=development pnpm i

COPY . .
RUN NODE_ENV=development pnpm i
RUN pnpm build

CMD ["node", "build"]
