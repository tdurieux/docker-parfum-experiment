FROM node:8.1-alpine

RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY package.json /opt/app/
RUN npm install --production && npm cache clean --force;

COPY . /opt/app
CMD ["npm", "start"];
