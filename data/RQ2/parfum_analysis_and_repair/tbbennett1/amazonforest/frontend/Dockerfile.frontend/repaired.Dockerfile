FROM node:10.13.0-alpine
WORKDIR /usr/src/app

COPY package.json /usr/src/app
COPY . /usr/src/app
RUN npm install && npm cache clean --force;

CMD ["npm", "start"]