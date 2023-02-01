#Building Scraper
FROM alpine:latest AS tiktok_scraper.build

WORKDIR /usr/app

RUN apk update && apk add --no-cache --update nodejs nodejs-npm python3

COPY package*.json tsconfig.json .prettierrc.js bin ./
COPY ./src ./src

RUN npm i && npm cache clean --force;
RUN npm run docker:build
RUN rm -rf src node_modules


#Using Scraper
FROM alpine:latest AS tiktok_scraper.use

WORKDIR /usr/app

RUN apk update && apk add --no-cache --update nodejs nodejs-npm

COPY --from=tiktok_scraper.build ./usr/app ./
COPY ./bin ./bin
COPY package* ./

ENV SCRAPING_FROM_DOCKER=1

RUN mkdir -p files
RUN npm i --production && npm cache clean --force;

ENTRYPOINT [ "node",  "bin/cli.js" ]
