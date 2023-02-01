FROM node:14.15-alpine3.10
RUN apk update && apk add --no-cache bash
RUN apk add --no-cache git
RUN apk add --no-cache ffmpeg
RUN apk add --no-cache imagemagick

ENV NODE_ENV=production

WORKDIR /pisignage-server

COPY ["package.json", "package-lock.json*", "./"]

#RUN rm -rf node_modues package-lock.json

RUN npm install --production && npm cache clean --force;

COPY . .
RUN chmod +x ./wait-for-it.sh

CMD [ "./wait-for-it.sh", "mongo:27017", "--", "node", "server.js"]