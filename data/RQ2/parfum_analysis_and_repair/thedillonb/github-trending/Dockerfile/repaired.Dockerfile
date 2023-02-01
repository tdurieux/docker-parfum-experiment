FROM node:10

ADD . /app

WORKDIR /app

RUN npm install && npm run build && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]
