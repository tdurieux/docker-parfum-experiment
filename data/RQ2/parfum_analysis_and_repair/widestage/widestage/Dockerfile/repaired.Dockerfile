FROM node:latest

MAINTAINER Widestage  <widestage.com>

RUN apt-get update && npm install -g bower && npm cache clean --force;

WORKDIR /srv/app/

COPY . /srv/app/

RUN npm install && npm cache clean --force;

RUN bower install --allow-root --force-latest

EXPOSE 80

CMD ["npm" , "start"]
