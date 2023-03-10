FROM node:13-alpine AS builder

RUN apk add --no-cache make python git g++ util-linux

WORKDIR /pomoday

COPY package.json .

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run dist

FROM halverneus/static-file-server:v1.7.0

ENV PORT 8888

COPY --from=builder /pomoday/dist /web
