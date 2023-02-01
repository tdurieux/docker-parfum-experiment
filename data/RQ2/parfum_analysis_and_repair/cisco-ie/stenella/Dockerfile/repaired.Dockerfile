FROM node:7.10

WORKDIR /app

ADD . /app

RUN npm install && npm cache clean --force;

EXPOSE 5000

CMD ["DEBUG=*", "npm", "start"]