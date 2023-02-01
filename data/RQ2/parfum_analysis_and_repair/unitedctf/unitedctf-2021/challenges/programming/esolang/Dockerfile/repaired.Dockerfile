FROM node:14 AS interpreter

WORKDIR /app

COPY ./interpreters/js/package*.json ./

RUN npm install && npm cache clean --force;

COPY ./interpreters/js/ .

RUN npm run webpack

FROM node:14 AS web

WORKDIR /app

COPY ./web/package*.json ./

RUN npm install && npm cache clean --force;

COPY ./web/. ./

COPY ./tests/. ./tests/

COPY ./challenges/. ./challenges/

COPY ./interpreters/js/. ./interpreter/

COPY --from=interpreter /app/out/ctfl.js ./public/

CMD npm start
