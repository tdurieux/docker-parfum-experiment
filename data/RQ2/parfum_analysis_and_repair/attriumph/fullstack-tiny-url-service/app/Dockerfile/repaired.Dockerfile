FROM node:8.9.3

RUN npm install nodemon -g && npm cache clean --force;

RUN mkdir -p /app

WORKDIR /app

ADD . /app

RUN cd /app && npm install && npm cache clean --force;

EXPOSE 3000

CMD ["nodemon", "/app/server.js"]