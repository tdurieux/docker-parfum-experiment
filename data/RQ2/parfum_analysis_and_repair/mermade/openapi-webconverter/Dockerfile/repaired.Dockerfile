FROM node:lts-alpine

RUN mkdir /app
ADD . /app

WORKDIR /app

RUN npm install && npm cache clean --force;

EXPOSE 3001

CMD [ "npm", "run", "start" ]
