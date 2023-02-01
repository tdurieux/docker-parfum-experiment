FROM node:alpine

WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN apk add --no-cache --update \
  && apk add --no-cache git \
  && npm install --production && npm cache clean --force;

ENV PORT 80
EXPOSE 80

COPY . .
CMD ["npm", "start"]
