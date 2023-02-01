FROM node:18

WORKDIR /app

COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000
EXPOSE 1883

CMD ["npm", "run", "start"]