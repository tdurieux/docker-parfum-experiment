FROM node:4

USER node

RUN mkdir /home/node/app

WORKDIR /home/node/app

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]

