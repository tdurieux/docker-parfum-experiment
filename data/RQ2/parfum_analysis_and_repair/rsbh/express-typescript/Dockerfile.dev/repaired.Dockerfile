FROM node:16

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8000

CMD ["npm", "run", "dev"]
