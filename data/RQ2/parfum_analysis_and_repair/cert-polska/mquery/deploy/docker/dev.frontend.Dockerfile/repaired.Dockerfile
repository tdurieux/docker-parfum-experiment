FROM node:16 AS build

RUN npm install -g serve && npm cache clean --force;
COPY src/mqueryfront /app
WORKDIR /app
RUN npm install && npm cache clean --force;
CMD ["npm", "start"]
