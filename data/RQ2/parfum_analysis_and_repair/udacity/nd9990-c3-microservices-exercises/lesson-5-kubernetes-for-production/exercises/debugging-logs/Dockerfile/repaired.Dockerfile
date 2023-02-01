FROM node:13

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080

CMD ["nohup", "node", "server.js", ">", "output.log", "&"]
