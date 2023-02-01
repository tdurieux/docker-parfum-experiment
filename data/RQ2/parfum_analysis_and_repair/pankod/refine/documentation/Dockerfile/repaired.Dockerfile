FROM node:16-alpine

WORKDIR /opt/app

RUN apk add --no-cache git openssh-client

ENV NODE_ENV production

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . /opt/app

RUN npm run build

FROM node:16-alpine

COPY --from=0 /opt/app/build /opt/app
WORKDIR /opt/app/

ENV NODE_ENV=production

RUN npm install -g serve && npm cache clean --force;

CMD serve -l 80
