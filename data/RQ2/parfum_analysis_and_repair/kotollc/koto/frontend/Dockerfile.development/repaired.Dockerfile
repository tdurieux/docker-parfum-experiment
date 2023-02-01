FROM node:alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --silent && npm cache clean --force;

COPY . ./

EXPOSE 3000

CMD ["npm", "run", "start"]
