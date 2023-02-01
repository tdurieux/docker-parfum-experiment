FROM node:10.12-alpine

RUN npm install -g gulp yarn && npm cache clean --force;

ADD . /app

WORKDIR /app

RUN yarn

CMD [ "gulp" ]
