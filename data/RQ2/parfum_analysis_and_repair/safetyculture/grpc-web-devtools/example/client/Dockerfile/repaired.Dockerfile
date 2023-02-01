FROM node:8

WORKDIR /usr/src/app

COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 8080
CMD [ "npm", "start" ]