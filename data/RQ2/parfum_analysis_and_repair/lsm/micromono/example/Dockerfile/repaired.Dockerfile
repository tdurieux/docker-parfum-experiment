FROM node:4


RUN npm --loglevel silent i -g istanbul jspm coveralls && npm cache clean --force;

WORKDIR /opt

EXPOSE 3000
