FROM node:12.16.1-buster

ENV IS_DOCKER=1

WORKDIR ~/app/buzzyblog
COPY . .

RUN npm install && npm run next:build && npm cache clean --force;

EXPOSE 8000
CMD ["node", "server.js" ]
