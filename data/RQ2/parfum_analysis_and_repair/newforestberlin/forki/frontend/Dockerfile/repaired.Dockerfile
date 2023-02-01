FROM node:10
COPY . /src
WORKDIR /src
RUN npm install && npm cache clean --force;
RUN npm rebuild node-sass
EXPOSE 4200