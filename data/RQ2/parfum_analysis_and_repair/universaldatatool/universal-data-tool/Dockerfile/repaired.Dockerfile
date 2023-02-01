FROM node:12

WORKDIR /usr/src/app

RUN npm install -g serve && npm cache clean --force;

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "run", "start:web:static"]
