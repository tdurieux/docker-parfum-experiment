FROM node:14.17.6
ADD package.json .
RUN npm install && npm cache clean --force;
RUN npm install express && npm cache clean --force;
ADD src src
RUN npm build
