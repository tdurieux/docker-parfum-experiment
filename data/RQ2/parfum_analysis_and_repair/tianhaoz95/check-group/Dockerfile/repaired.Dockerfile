FROM node:12

WORKDIR /app

COPY . .

RUN npm install && npm run build && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]
