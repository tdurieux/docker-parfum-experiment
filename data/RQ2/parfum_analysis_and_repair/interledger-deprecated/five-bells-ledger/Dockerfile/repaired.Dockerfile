FROM node:7.10

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD [ "npm", "start" ]
