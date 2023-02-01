FROM node:10-alpine

WORKDIR /usr/instapy

COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 80

CMD ["npm", "start"]