# build angular app
FROM node:carbon

WORKDIR /app

ADD greenlight-demo /app

RUN npm install && npm cache clean --force;

ENV PATH="/app/node_modules/@angular/cli/bin:${PATH}"

RUN ng build --prod
