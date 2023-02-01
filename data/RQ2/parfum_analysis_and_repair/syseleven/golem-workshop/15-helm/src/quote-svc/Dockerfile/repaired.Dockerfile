FROM node:16-alpine

ENV NODE_ENV production

RUN mkdir /app

WORKDIR /app

COPY package*.json /app/

RUN npm install && npm cache clean --force;

COPY . /app/

EXPOSE 3000

ENTRYPOINT ["node", "quote-svc.js"]
