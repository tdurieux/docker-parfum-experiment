FROM node:8 AS build
WORKDIR /src
ADD package.json ./
RUN npm install && npm cache clean --force;
EXPOSE 5432
CMD [ "npm", "start" ]
