FROM node:17-alpine

WORKDIR /usr/app

COPY package.json .
RUN npm i && npm cache clean --force;
COPY . .

CMD ["node", "SkinPeek.js"]
