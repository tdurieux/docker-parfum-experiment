FROM node:10-alpine
COPY nodejs-app/ /app
WORKDIR /app
RUN npm install cassandra-driver && npm cache clean --force;
RUN npm install async && npm cache clean --force;

CMD ["node", "part1_app.js"]
