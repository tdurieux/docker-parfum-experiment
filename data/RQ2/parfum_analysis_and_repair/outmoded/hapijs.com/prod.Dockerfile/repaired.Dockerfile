FROM node:8

WORKDIR /app
EXPOSE 3000

ADD . /app
RUN npm install && npm test && npm cache clean --force;

CMD ["npm", "start"]
