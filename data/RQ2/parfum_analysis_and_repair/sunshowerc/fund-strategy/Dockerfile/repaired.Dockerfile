FROM node:14-alpine

WORKDIR /app

COPY . .

RUN npm install && npm cache clean --force;

CMD ["npm", "start"]
