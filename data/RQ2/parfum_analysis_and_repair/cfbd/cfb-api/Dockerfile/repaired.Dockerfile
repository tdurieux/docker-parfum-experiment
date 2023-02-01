FROM node:10-alpine

RUN mkdir -p /home/node/app/node_modules && mkdir -p /home/node/app/dist && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

RUN npm install pm2 -g && npm cache clean --force;
RUN npm install && npm cache clean --force;

COPY . .
COPY --chown=node:node . .

RUN npm start

USER node

EXPOSE 8080

CMD [ "pm2-runtime", "server.js" ]
