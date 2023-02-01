FROM node:14.15.1-alpine3.12 AS node

WORKDIR /usr/src/app

COPY . .

RUN npm install

RUN npm run build

FROM nginx:latest

WORKDIR /usr/share/nginx/html

COPY --from=node /usr/src/app/dist/oauth2-ui .

COPY nginx.config /etc/nginx/conf.d/default.conf

EXPOSE 80