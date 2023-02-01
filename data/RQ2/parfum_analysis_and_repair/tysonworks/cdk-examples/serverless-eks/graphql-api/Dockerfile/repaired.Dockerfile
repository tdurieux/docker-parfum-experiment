FROM node:alpine

WORKDIR /app

COPY . .

RUN npm i npm@latest -g && npm cache clean --force;
RUN npm install --only=production && npm cache clean --force;

EXPOSE 8090

ENTRYPOINT ["/bin/sh", "start"]