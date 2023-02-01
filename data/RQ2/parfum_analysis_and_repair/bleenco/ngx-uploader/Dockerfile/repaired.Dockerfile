FROM node:14-alpine

COPY . /app

WORKDIR /app

RUN npm install && npm run build:prod && npm cache clean --force;

ENTRYPOINT [ "node", "/app/dist/api/index.js" ]

EXPOSE 4900
