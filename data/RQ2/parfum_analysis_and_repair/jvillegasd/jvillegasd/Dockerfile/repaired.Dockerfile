FROM node:alpine

RUN mkdir -p /app
WORKDIR /app/api

RUN npm install --global nodemon && npm cache clean --force;

COPY ./api/package*.json ./
RUN npm install --quiet --no-optional && npm cache clean --force;

EXPOSE ${NODEJS_PORT}

CMD nodemon index.js