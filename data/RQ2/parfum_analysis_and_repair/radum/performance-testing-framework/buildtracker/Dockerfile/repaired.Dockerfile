FROM node:12

WORKDIR /usr/src/buildtracker
COPY package.json .
COPY build-tracker.config.js .
RUN npm install && npm cache clean --force;

EXPOSE 9002
CMD [ "npm", "start" ]
