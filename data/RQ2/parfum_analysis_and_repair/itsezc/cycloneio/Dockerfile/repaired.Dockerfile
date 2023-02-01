FROM node:12

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8085

CMD ["npm", "run", "lerna:dev:badge"]