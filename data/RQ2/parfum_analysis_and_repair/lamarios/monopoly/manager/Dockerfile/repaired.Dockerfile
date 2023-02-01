FROM node:alpine

EXPOSE 8080

RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN npm install && npm cache clean --force;
CMD npm start