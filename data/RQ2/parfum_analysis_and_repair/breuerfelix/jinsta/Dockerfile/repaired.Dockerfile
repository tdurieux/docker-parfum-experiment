FROM node:12

WORKDIR /usr/app

COPY . .

RUN npm install && npm run build && npm cache clean --force;

EXPOSE 80

CMD ["npm", "start"]
