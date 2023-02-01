FROM node:8

EXPOSE 8080

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ADD . /usr/src/app 
RUN npm install --production && npm cache clean --force;

CMD ["npm", "start"] 
