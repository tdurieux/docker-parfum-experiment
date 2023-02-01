FROM node:latest

RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash
RUN npm i -g nodemon sequelize-cli && npm cache clean --force;

WORKDIR /var/www/workshop

ADD . /var/www/workshop

RUN yarn install && yarn cache clean;

CMD ["docker/start.sh"]
