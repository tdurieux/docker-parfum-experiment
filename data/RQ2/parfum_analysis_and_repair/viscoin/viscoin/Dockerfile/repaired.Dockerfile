FROM node:16

WORKDIR /viscoin

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 80 9332 9333

RUN npm run c

CMD [ "node", "fullnode.js" ]
