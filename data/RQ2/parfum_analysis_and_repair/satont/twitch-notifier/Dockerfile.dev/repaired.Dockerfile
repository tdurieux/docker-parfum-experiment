FROM node:16-alpine

RUN apk add --no-cache bash
RUN npm i -g pnpm && npm cache clean --force;
RUN pnpm config set store-dir ~/.pnpm-store

EXPOSE 3000
EXPOSE 9229

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY . /app
RUN pnpm run build

CMD [ "pnpm", "dev" ]