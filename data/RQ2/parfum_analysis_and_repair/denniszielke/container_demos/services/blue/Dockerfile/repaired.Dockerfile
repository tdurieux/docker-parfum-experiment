FROM node:8.2.0-alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
COPY ./app/* /usr/src/app/
WORKDIR /usr/src/app
RUN npm install && npm cache clean --force;
EXPOSE 80
CMD node /usr/src/app/index.js
