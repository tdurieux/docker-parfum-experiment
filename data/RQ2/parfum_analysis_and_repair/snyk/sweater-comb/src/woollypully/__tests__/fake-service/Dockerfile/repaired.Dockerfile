FROM node:14-alpine AS build-env
WORKDIR /fake-service
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 8080
ENTRYPOINT [ "node", "index.js" ]
