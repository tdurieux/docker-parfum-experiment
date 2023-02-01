FROM node:10

RUN npm i -g npm && npm cache clean --force;

RUN mkdir /app
WORKDIR /app

ADD ./package.json .
ADD ./package-lock.json .

RUN npm install && npm cache clean --force;

CMD npm run migrate && npm run seed && npm start