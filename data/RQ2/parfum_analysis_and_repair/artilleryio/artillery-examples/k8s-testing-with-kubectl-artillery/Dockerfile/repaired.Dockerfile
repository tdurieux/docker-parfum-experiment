FROM node:16-alpine

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm --production install && npm cache clean --force;

COPY . .

EXPOSE 3001

CMD ["node", "app.js"]
