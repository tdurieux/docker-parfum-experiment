FROM node:8

EXPOSE 3000
WORKDIR /app
COPY package.json index.js ./
RUN npm install && npm cache clean --force;

CMD ["npm", "start"]
