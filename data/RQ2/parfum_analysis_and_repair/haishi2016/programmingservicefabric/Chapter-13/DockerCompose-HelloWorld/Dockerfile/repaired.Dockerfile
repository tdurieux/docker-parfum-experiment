FROM node:alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY ./package.json /usr/src/app
RUN npm install && npm cache clean --force;

COPY ./server.js /usr/src/app

EXPOSE 8180

CMD ["npm", "start"]