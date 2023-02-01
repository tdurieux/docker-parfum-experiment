FROM node:10

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run postinstall

EXPOSE 3000

CMD [ "npm", "start" ]
