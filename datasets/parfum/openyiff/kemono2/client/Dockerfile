# syntax=docker/dockerfile:1

FROM node:16.14

ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "package-lock.json", "/app/"]

RUN npm install -g npm
RUN npm ci --also=dev

COPY . /app

CMD [ "npm", "run", "build" ]