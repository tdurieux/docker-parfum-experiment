FROM node:14-alpine

WORKDIR /usr/local/share/backend

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 5000

CMD npm run start
