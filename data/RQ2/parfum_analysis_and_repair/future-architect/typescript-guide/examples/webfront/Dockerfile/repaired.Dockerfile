# ここから下がビルド用イメージ

FROM node:12-buster AS builder

WORKDIR app
COPY package.json package-lock.json ./
RUN npm ci --no-optional
COPY tsconfig.json ./
COPY public ./public
COPY src ./src
RUN npm run build

# ここから下が実行用イメージ