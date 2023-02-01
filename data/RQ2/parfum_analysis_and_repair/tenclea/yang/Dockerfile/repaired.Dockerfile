FROM node:16.6.2-alpine3.14

WORKDIR app

COPY . .

RUN npm install && npm cache clean --force;

CMD ["node", "."]
