FROM node:10-alpine

RUN apk -U upgrade

COPY . /app

WORKDIR /app

RUN npm install && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]
