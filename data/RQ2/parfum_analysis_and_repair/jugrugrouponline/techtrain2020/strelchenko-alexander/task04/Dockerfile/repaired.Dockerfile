FROM node:14.4.0-alpine3.10
WORKDIR /usr/src/app
COPY ./package.json .
RUN npm install && npm cache clean --force;
EXPOSE 8083
COPY ./main.js .
ENTRYPOINT ["node", "./main.js"]