FROM node:12.16.0-alpine

WORKDIR /usr/src/app
COPY src/package*.json ./
RUN npm install && npm cache clean --force;

COPY src/ .

EXPOSE 3000

CMD [ "npm", "start" ]