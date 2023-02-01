FROM node:14

WORKDIR /usr/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000
CMD [ "node", "src/app.js" ]
