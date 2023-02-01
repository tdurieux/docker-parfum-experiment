FROM node:0.11.14

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ADD ${deployableFilename} /usr/src/app
RUN npm install && npm cache clean --force;
EXPOSE 8080

CMD [ "npm", "start" ]