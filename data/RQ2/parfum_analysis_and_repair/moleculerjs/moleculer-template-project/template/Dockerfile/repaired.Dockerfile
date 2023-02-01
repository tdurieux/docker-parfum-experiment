FROM node:current-alpine

ENV NODE_ENV=production

RUN mkdir /app
WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install --production && npm cache clean --force;

COPY . .

CMD ["npm", "start"]
