FROM node:6.3.1

RUN npm install nodemon -g && npm cache clean --force;

RUN mkdir -p /app

WORKDIR /app

ADD . /app

RUN cd /app && npm install && npm cache clean --force;

EXPOSE 3000

CMD ["nodemon", "/app/server.js"]