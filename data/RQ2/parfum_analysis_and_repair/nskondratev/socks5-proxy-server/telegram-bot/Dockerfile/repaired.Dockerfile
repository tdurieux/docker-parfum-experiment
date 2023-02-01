FROM node:14.17.3

ADD . /app

WORKDIR /app

RUN npm install pm2 -g && npm cache clean --force;

RUN npm i --production --unsafe && npm cache clean --force;

CMD ["pm2", "start", "app.js", "--no-daemon", "--name", "telegram-bot"]
