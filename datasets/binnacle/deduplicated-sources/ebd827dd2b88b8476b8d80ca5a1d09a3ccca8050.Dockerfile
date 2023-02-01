FROM node:12-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --development

COPY . .

RUN npm run build

FROM node:12-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --production

COPY --from=builder /usr/src/app/dist ./

USER node

ENV NODE_ENV=production

CMD ["node", "-r", "source-map-support/register", "index.js"]
