FROM node:14-alpine3.10

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

RUN npm install pm2 -g && npm cache clean --force;

COPY . .

RUN npm run build

CMD pm2-runtime 'npm start'
