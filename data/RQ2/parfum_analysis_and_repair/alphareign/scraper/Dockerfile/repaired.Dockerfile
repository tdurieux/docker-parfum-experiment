FROM node:8-alpine

ADD . /scraper
WORKDIR /scraper

RUN yarn \
 && yarn global add pm2 && yarn cache clean;

CMD ["/usr/local/bin/pm2-runtime", "start", "ecosystem.config.js"]
