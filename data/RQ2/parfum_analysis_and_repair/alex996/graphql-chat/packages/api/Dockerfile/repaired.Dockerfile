FROM node:12-alpine AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=development && npm cache clean --force;

COPY . .

RUN npm run build

FROM node:12-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production && npm cache clean --force;

COPY --from=builder /usr/src/app/dist ./

USER node

ENV NODE_ENV=production

CMD ["node", "-r", "source-map-support/register", "index.js"]
