FROM node:16

WORKDIR /app

COPY package*.json ./

RUN npm install --silent && npm cache clean --force;

COPY app.js ./

CMD ["npm", "start"]
