FROM node:current

COPY package.json websocket-server.js /usr/app/
COPY config.example.js /usr/app/config.js

WORKDIR /usr/app

RUN npm install && npm cache clean --force;
RUN npm install pm2 -g && npm cache clean --force;

EXPOSE 3000

CMD [ "pm2-runtime", "websocket-server.js" ]