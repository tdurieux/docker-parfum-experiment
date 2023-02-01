FROM node:14

WORKDIR /usr/src/app

COPY package.json /usr/src/app

RUN npm install && npm cache clean --force;

COPY . /usr/src/app

EXPOSE 5000

CMD ["npm", "start"]