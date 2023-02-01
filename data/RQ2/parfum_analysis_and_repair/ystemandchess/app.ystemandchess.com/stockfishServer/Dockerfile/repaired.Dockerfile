FROM node:alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;
RUN npm ci --only=production

COPY . .

EXPOSE 8080
CMD [ "node", "index.js" ]
