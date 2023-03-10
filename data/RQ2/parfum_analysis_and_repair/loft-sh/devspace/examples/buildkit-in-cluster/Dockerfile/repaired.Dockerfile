FROM node:13.14-alpine

RUN mkdir /app
WORKDIR /app

COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "start"]
