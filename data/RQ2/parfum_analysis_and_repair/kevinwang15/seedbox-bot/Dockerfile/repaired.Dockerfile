FROM alpine:3 as build-env

RUN apk add --no-cache --upgrade nodejs npm alpine-sdk python

ADD . /build
RUN npm i -g babel-cli && npm cache clean --force;
WORKDIR /build
RUN npm i && npm cache clean --force;
WORKDIR /build/bot
RUN npm i && npm cache clean --force;
WORKDIR /build/server
RUN npm i && npm cache clean --force;
WORKDIR /build/ui
RUN npm i && npm cache clean --force;
WORKDIR /build
RUN npm run bundle

FROM alpine:3
COPY --from=build-env /build/production-bundle /production
COPY --from=build-env /build/bot/node_modules /production/bot/node_modules
COPY --from=build-env /build/server/node_modules /production/server/node_modules
RUN apk add --no-cache nodejs npm
RUN npm install -g pm2 sequelize-cli && npm cache clean --force;
WORKDIR /production
RUN mkdir torrents
RUN chmod -R 777 torrents bot
WORKDIR /production
ADD ./process.yml /production
CMD ["pm2-runtime", "process.yml"]
