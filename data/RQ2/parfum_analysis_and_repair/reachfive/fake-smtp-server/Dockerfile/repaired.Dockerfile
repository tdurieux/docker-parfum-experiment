FROM node:10.15.2-alpine

COPY . /www

WORKDIR /www

RUN npm i && npm run build && npm cache clean --force;

EXPOSE 1025
EXPOSE 1080

CMD ["node", "index.js"]
