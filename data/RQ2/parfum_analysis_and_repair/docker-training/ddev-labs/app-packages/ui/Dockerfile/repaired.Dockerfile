FROM node:8-alpine
RUN mkdir /app
WORKDIR /app
COPY package.json /app/
RUN npm install && npm cache clean --force;
COPY ./src /app/src
EXPOSE 3000
CMD node src/server.js