FROM node:8.5

RUN mkdir /app
WORKDIR /app

ADD ./package.json .
ADD ./package-lock.json .

RUN npm install && npm cache clean --force;

CMD npm run start
