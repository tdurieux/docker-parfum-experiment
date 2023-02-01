FROM daocloud.io/library/node:7.9-wheezy

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080
CMD [ "npm", "start" ]