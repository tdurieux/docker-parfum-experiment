FROM node:9.5.0-alpine

WORKDIR /app
COPY . .

RUN npm install --production && npm cache clean --force;

EXPOSE 3000
CMD ["node", "app/index.js"]