FROM node:lts-alpine as build

WORKDIR /app

COPY . /app

RUN apk add --no-cache make
RUN pwd
RUN npm i -g typescript && npm cache clean --force;
RUN npm i -g lerna && npm cache clean --force;
RUN npm i -g copyfiles && npm cache clean --force;

RUN npm install && npm cache clean --force;
RUN make build.staging.feed.static

FROM nginx:stable
COPY --from=build /app/examples/ui/ethereum.world/public /usr/share/nginx/html

EXPOSE 80
