FROM node:9.4.0-alpine

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD [ "npm", "run", "container" ]


