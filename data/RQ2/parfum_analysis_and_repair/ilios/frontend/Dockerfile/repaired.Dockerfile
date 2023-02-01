FROM node:carbon

MAINTAINER Ilios Project Team <support@iliosproject.org>

WORKDIR /web
ENV PATH=/web/node_modules/.bin:$PATH
COPY . /web

RUN npm install && npm cache clean --force;

CMD ["npm", "start"]
EXPOSE 4200
