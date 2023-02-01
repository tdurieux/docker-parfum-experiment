FROM node:16-alpine

WORKDIR /usr/src/app

COPY package.json ./
RUN npm i && npm cache clean --force;
COPY . .

CMD [ "npm", "start" ]
