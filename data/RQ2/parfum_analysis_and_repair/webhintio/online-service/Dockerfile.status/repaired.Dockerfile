FROM node:lts

WORKDIR /app

COPY package.json /app

RUN npm install && npm cache clean --force;

COPY . /app

RUN npm run build

CMD node dist/src/bin/online-service.js --microservice status
