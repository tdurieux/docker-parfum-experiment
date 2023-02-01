FROM node:15.8.0

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000
CMD ["npm", "start"]