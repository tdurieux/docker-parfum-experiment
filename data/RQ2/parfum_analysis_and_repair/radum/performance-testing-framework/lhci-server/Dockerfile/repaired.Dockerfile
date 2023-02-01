FROM node:12-buster-slim

WORKDIR /usr/src/lhci
COPY package.json .
COPY lighthouserc.json .
RUN npm install && npm cache clean --force;

EXPOSE 9001
CMD [ "npm", "start" ]
