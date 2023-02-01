FROM node:14-alpine
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
CMD [ "npm", "start" ]
EXPOSE 3000
