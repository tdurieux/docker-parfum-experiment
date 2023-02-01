FROM node:0.12

RUN mkdir /code
WORKDIR /code

ADD package.json /code/
RUN npm install && npm cache clean --force;

ADD . /code

EXPOSE 7007
