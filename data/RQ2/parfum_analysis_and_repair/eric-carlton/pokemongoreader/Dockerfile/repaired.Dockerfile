FROM node:6.3

ENV PATH=./node_modules/.bin:$PATH

RUN mkdir /app
WORKDIR /app
COPY ./ ./

RUN npm install && typings install && npm cache clean --force;

EXPOSE 8080 8008
CMD npm start
