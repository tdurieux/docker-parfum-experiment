FROM node:carbon

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production && npm cache clean --force;

COPY . .

RUN npm run build

EXPOSE 3000

CMD [ "npm", "start" ]