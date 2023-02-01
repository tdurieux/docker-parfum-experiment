FROM node

WORKDIR /usr/src/app

COPY package*.json client.js index.html rest-server.js UserModel.js ./

RUN npm install --production

EXPOSE 3000

CMD ["npm", "start"]
