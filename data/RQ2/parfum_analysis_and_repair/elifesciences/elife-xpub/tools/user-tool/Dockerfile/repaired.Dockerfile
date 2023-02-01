FROM node:10

WORKDIR /

ADD ./src .
RUN npm install superagent && npm cache clean --force;

CMD []
