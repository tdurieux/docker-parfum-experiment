# docker build . -t kvn0218/kuma-demo-be:v1
# docker push kvn0218/kuma-demo-be:v1

FROM node:lts-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3001

RUN apk add --no-cache curl

CMD [ "npm", "start" ]