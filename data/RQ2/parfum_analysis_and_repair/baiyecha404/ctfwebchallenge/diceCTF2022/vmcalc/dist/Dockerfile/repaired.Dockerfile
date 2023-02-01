FROM node:16.13.1-bullseye-slim

RUN mkdir -p /app

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY . .

USER node

CMD ["node", "index.js"]