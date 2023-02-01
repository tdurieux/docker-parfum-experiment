FROM node:14-alpine

RUN mkdir -p /app

WORKDIR /app

COPY package.json .

RUN npm install && npm cache clean --force;

COPY . .

CMD ["node", "index.js"]