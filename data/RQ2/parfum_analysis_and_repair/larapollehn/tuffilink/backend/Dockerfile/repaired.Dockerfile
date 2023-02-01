FROM node:alpine

WORKDIR /app

COPY package.json .

RUN npm install --silent && npm cache clean --force;

COPY . .

CMD ["npm", "run", "production"]