FROM node:14.0.0-alpine3.11
COPY ./server.js server.js
COPY ./package.json package.json
RUN npm install
EXPOSE 5000
CMD [ "node","./server.js" ] 
