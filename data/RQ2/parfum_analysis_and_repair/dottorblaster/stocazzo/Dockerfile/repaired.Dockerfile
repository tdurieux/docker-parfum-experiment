FROM node:16

ENV PORT=8080

WORKDIR /usr/src/app

COPY . .

RUN npm install && npm cache clean --force;

RUN npm run build

EXPOSE 8080

CMD [ "node", "dist/index.js" ]
