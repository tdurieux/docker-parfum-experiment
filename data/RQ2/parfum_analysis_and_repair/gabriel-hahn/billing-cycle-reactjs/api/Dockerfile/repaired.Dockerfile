FROM node:alpine

WORKDIR /usr/app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3333

CMD ["npm", "run", "start"]
