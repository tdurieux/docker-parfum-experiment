FROM node:alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
COPY ./app/* /usr/src/app/
WORKDIR /usr/src/app
RUN npm install && npm cache clean --force;
CMD node /usr/src/app/index.js
