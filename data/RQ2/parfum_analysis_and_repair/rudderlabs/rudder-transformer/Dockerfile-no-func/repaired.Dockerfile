FROM node:10.16.0-alpine

# Create app directory
WORKDIR /app

COPY package*.json ./
COPY build.js ./

RUN npm install --unsafe-perm && npm cache clean --force;

COPY . .

CMD [ "npm", "start" ]
