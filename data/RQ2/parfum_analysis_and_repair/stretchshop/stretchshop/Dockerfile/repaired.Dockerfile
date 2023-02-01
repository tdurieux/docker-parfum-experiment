FROM node:lts-alpine

RUN mkdir /app
WORKDIR /app

ENV NODE_ENV=production

COPY package.json .

RUN npm install npm@latest && npm cache clean --force;

RUN npm install --silent --progress=false --production --ignore-scripts && npm cache clean --force;

COPY . .

CMD ["npm", "start"]
