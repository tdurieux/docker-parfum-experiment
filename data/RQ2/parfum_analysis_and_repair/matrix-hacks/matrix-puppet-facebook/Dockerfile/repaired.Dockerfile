FROM node:10-alpine

WORKDIR /usr/src/app

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

COPY . .

RUN apk add --no-cache git ffmpeg
RUN npm install && npm cache clean --force;

EXPOSE 8090
CMD [ "npm", "start" ]
