FROM node:8.8-alpine
RUN mkdir /app
WORKDIR /app
ADD package.json .
RUN npm install && npm cache clean --force;
ADD . .
CMD ["node", "server.js"]