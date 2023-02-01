FROM node:14.18.2 as builder

WORKDIR /src/app
COPY ./code ./

RUN yarn install && yarn build:prod && yarn cache clean;

FROM nginx:stable-alpine

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /src/app/dist/labeltool/ /usr/share/nginx/html

EXPOSE 80
