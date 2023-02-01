FROM alpine:latest

WORKDIR /app

COPY package.json /app

COPY . /app

RUN apk add --no-cache --update nodejs npm
RUN npm install -g express && npm cache clean --force;

CMD [ "node", "index.js" ]
