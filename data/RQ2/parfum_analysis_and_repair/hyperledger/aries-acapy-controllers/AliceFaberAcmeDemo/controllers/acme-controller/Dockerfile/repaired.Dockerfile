FROM node:10 as build
COPY . .
RUN npm install && npm cache clean --force;
ENTRYPOINT [ "npm", "start" ]
