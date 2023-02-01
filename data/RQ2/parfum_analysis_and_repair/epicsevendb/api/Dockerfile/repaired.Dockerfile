FROM node:12.14.0

WORKDIR /usr/src

ADD package*.json ./

RUN npm install && npm cache clean --force;

ADD . .

RUN npm run build

CMD [ "npm", "run", "start" ]
