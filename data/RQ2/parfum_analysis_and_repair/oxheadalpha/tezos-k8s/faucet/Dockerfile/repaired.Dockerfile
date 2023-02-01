FROM node:8-alpine

WORKDIR .

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "npm", "start" ]

