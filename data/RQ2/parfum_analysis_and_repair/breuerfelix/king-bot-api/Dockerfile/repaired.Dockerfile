FROM node:lts-alpine

WORKDIR /usr/kingbot

COPY . .

RUN npm install && npm run build && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]
