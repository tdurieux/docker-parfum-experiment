FROM node:8.9.4-slim

COPY . /usr/src
WORKDIR /usr/src

RUN npm install && npm cache clean --force;

CMD ["node", "."]

EXPOSE 8080
