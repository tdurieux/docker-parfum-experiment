FROM node:12.18.3

RUN npm install -g standard && npm cache clean --force;

RUN mkdir /code
WORKDIR /code

RUN mkdir /.cache
RUN chmod 777 /.cache
