FROM node:latest

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app

WORKDIR /usr/src/app/client

RUN npm install && npm run build && npm cache clean --force;

WORKDIR /usr/src/app/server

RUN npm install && npm cache clean --force;

EXPOSE 3003

CMD ["npm", "run", "prod"]