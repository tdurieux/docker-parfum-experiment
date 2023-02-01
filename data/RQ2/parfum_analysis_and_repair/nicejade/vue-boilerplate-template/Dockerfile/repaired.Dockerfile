FROM node

MAINTAINER nicejade

COPY . /app

WORKDIR /app

RUN npm install && npm cache clean --force;

EXPOSE 8080

CMD npm start