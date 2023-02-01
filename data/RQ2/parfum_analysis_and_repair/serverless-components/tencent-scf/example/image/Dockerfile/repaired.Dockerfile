FROM node:12.16

WORKDIR /usr/src/app
COPY ./src .
RUN npm install && npm cache clean --force;

EXPOSE 9000

CMD [ "node", "./index.js" ]
