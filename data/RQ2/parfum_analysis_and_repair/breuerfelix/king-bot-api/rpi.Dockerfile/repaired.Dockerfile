FROM balenalib/raspberry-pi-alpine-node:10

WORKDIR /usr/kingbot

COPY . .

RUN npm install && npm run build && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]

