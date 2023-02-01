FROM node:14

ENV APP_PORT="3000"

WORKDIR /app

COPY package*.json ./

RUN npm install --only=production && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
