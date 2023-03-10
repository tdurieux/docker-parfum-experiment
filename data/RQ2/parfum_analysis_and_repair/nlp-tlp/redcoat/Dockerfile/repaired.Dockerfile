FROM node:15

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

RUN npm update node-sass

COPY . .

EXPOSE 3000
CMD ["node", "./bin/www"]
