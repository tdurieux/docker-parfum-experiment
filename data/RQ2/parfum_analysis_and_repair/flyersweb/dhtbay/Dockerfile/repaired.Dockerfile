FROM keymetrics/pm2:6-jessie

RUN groupadd -r app && useradd -r -g app app

ADD . /var/www
WORKDIR /var/www

RUN npm install --no-optional && npm cache clean --force;
CMD [ "pm2-runtime", "start", "ecosystem.config.js" ]
