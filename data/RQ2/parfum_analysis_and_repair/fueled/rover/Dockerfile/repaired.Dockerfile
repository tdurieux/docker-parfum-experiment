FROM node:8-slim

WORKDIR /starter
ENV NODE_ENV development

COPY package.json /starter/package.json

RUN npm install --production && npm cache clean --force;

COPY .env.example /starter/.env.example
COPY . /starter

CMD ["npm","start"]

EXPOSE 8080
