FROM node:latest

RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash
RUN npm i -g typescript ts-node && npm cache clean --force;

WORKDIR /var/www/lingviny-api

ADD . /var/www/lingviny-api

RUN yarn install && yarn cache clean;

EXPOSE 3000

CMD ["docker/start.sh"]

