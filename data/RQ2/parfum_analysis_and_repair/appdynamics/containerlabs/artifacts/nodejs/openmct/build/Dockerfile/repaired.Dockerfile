FROM node:10.16.0-alpine

WORKDIR /openmct

COPY ./ /openmct

RUN npm install && npm cache clean --force;

EXPOSE 8080

CMD [ "node", "app.js" ]