FROM node:13

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

VOLUME /data

CMD ["index.js"]
