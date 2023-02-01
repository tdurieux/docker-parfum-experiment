FROM node:16

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install && npm cache clean --force;
COPY . .


RUN npm run build:all

CMD [ "npm", "run", "bench:all" ]
