FROM node:alpine

WORKDIR /app

ADD .  /app
RUN npm install && npm cache clean --force;

CMD ["npm", "test"]
