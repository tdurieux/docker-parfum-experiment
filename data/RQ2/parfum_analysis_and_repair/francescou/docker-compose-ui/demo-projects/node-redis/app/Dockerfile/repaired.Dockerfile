FROM node:7-alpine

WORKDIR /opt

RUN npm install redis express && npm cache clean --force;

EXPOSE 8080

ADD ./app.js /opt/

CMD ["node", "/opt/app.js"]
