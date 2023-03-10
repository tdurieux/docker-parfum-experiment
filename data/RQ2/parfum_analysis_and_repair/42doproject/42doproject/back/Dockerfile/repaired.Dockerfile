FROM node:14.17.5-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm install typescript && npm cache clean --force;
COPY . .

EXPOSE 5000
CMD [ "npm", "start" ]
