FROM node:10
COPY . /src
WORKDIR /src
RUN npm install && npm cache clean --force;
EXPOSE 3001
