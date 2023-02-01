FROM node:lts-alpine

RUN npm install -g history-server && npm cache clean --force;

WORKDIR /app

COPY ./dist .

EXPOSE 8080
CMD [ "history-server", "./" ]
