# latest official node image
FROM node:latest

RUN npm install -g nginx && npm cache clean --force;

RUN mkdir /webapp
WORKDIR /webapp
ADD package.json ./package.json
RUN npm install --unsafe-perm && npm cache clean --force;
ADD . ./

ENV PORT=80

CMD npm start
