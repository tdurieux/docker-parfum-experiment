FROM node:11
WORKDIR /app
COPY package*.json  ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 5555
CMD ["node", "index.js"]