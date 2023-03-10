FROM node:12.18.0-stretch

WORKDIR /app/

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "/app/src/index.js" ]
