FROM node:6-slim
RUN mkdir -p /app
ADD . /app
RUN cd /app && npm install && npm cache clean --force;
CMD node /app/broker.js
