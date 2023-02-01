FROM node:16.13.0-alpine

WORKDIR /app

ENV NODE_ENV=production

ENV PORT=8085

COPY package.json /app

RUN npm install pm2 -g && npm cache clean --force;

RUN npm install --production --force && npm cache clean --force;

COPY . /app

CMD ["npm","run","start:prod"]