FROM node:6

MAINTAINER xVir <danil.skachkov@speaktoit.com>

RUN mkdir -p /usr/app/src

WORKDIR /usr/app
COPY . /usr/app

EXPOSE 5000

RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
