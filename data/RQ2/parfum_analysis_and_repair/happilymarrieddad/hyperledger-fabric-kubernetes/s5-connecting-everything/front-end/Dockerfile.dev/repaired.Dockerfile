FROM node:10.15.3-alpine

WORKDIR /app

COPY ./package.json ./
RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "run", "serve"]
