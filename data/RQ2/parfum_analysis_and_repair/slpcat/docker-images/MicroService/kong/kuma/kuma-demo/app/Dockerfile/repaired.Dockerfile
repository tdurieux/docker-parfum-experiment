FROM node:lts-alpine

RUN npm install -g http-server @vue/cli && npm cache clean --force;

WORKDIR /app

COPY package*.json ./

# RUN npm install
RUN npm install && npm cache clean --force;

COPY . .

RUN npm rebuild node-sass

RUN npm run build

RUN apk add --no-cache curl jq

EXPOSE 8080
ENTRYPOINT [ "http-server", "dist"]
