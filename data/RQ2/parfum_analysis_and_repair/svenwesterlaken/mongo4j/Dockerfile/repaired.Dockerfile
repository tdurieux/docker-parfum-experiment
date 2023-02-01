FROM node

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm i --only=dev && npm cache clean --force;

COPY . .

VOLUME /usr/src/app

CMD ["npm", "start"]
