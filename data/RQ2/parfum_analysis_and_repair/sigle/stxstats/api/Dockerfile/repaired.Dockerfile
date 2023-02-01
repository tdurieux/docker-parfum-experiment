# Stage 1 - build the api server
FROM node:16-alpine AS BUILD_SERVER

WORKDIR /usr/src/app

RUN wget -qO- https://get.pnpm.io/v6.16.js | node - add --global pnpm

COPY package.json pnpm-*.yaml ./
COPY api/package.json ./api/

RUN pnpm install --frozen-lockfile --filter=api

COPY . .

RUN pnpm prisma:generate --filter=api
RUN pnpm run build --filter=api

# Stage 2 - Run the built application