FROM node:10.16-alpine

WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;

CMD [ "npm", "start" ]