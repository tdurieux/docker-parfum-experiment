FROM node:9-alpine

WORKDIR /opt/scrobblerbot
COPY package.json package-lock.json ./
COPY ./src ./src
RUN npm install && npm cache clean --force;
EXPOSE 8443
CMD npm run watch