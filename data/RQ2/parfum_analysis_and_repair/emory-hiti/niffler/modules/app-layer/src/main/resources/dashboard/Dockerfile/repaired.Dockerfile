FROM node:12-alpine
RUN mkdir /src
COPY . /src
WORKDIR /src
RUN npm install && npm cache clean --force;
EXPOSE 8888

CMD node index.js
