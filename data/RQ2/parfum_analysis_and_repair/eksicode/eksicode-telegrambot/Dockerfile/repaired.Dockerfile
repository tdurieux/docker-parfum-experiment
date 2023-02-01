FROM node:14

RUN mkdir /var/bot/

WORKDIR /var/bot/

COPY . /var/bot/

RUN npm install && npm cache clean --force;

RUN npm install pm2 -g && npm cache clean --force;

CMD [ "pm2-runtime", "start", "pm2.json" ]
