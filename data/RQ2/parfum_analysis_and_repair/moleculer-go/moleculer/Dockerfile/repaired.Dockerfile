FROM node:10-alpine

ENV NODE_ENV=production

RUN mkdir /app
WORKDIR /app

COPY package.json .

RUN npm install --production && npm cache clean --force;

COPY . .

CMD ["npm", "start"]