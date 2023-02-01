FROM node:8-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app

RUN npm install && npm cache clean --force;

COPY . /usr/src/app

EXPOSE 4200

CMD ["npm", "start"]