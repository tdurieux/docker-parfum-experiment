FROM node
RUN npm install -g supervisor && npm cache clean --force;
ADD . /usr/src/app
WORKDIR /usr/src/app
EXPOSE 80
ENV PORT 80
ENTRYPOINT supervisor index.js
