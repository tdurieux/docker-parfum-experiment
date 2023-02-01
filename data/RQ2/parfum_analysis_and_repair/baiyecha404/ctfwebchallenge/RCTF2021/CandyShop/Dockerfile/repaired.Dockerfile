FROM node:alpine

COPY src /app
COPY flag /flag

RUN cd /app && npm update -g && npm install && adduser meow -D && npm cache clean --force;

USER meow

CMD cd /app && node app.js