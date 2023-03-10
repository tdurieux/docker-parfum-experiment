FROM node:12.16-alpine
ARG FRONTEND

WORKDIR /app

RUN apk add --update --no-cache git bash yarn nano

RUN npm install -g serve && npm cache clean --force;

COPY ./$FRONTEND /app/

RUN npm install && npm cache clean --force;

RUN npm run build

CMD serve -s build -l 5000
