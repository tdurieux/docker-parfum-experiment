FROM node:14

WORKDIR /usr/src/app

COPY . .

RUN npm install && npm cache clean --force;

CMD ["node", "server.js" ]
