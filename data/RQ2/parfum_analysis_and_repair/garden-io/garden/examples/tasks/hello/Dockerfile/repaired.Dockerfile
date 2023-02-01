FROM node:12.22.6-alpine

ENV PORT=8080
EXPOSE ${PORT}
WORKDIR /app

ADD package.json /app
RUN npm install knex -g && npm cache clean --force;
RUN npm install && npm cache clean --force;

ADD . /app

CMD ["npm", "start"]
