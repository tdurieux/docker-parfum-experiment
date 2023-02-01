FROM node:9.4.0-alpine

WORKDIR /usr/app

COPY package*.json ./
RUN npm install -qy && npm cache clean --force;

COPY . .

EXPOSE 8080

CMD ["npm", "start"]
