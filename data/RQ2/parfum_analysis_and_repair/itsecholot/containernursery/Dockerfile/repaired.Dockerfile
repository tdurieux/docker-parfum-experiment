FROM node:17-alpine

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;

COPY . .
EXPOSE 80
CMD ["node", "build/index.js"]