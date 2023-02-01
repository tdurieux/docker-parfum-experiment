FROM node:16.14-slim as builder

WORKDIR /opt

ADD . ./

RUN npm install && npm run build:prod && npm cache clean --force;

FROM nginx:1.20

COPY --from=builder /opt/dist/ /usr/local/nginx/html/