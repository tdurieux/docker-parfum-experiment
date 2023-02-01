FROM node:9.4.0-alpine
COPY app.js .
COPY package.json .
RUN npm install &&\
    apk update && \
    apk upgrade && npm cache clean --force;
EXPOSE  8080
CMD node app.js