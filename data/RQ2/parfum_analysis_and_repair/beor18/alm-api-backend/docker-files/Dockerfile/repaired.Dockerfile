FROM node:12

WORKDIR /usr/docker-prueba/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 5000:5000
CMD [ "npm", "run", "dev"]