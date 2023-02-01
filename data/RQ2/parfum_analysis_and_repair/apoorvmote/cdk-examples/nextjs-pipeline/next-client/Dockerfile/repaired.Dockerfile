FROM node:14.15.1-alpine3.12

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app

COPY package-lock.json /usr/src/app

RUN npm install --production && npm cache clean --force;

COPY . /usr/src/app

RUN npm run build

EXPOSE 80

CMD [ "npm", "start" ]