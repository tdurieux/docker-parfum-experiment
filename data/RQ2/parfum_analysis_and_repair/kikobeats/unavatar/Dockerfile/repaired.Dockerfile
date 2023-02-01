FROM node:14
COPY . /app
WORKDIR /app
RUN npm install --only=production && npm cache clean --force;

CMD ["node", "src/server.js"]
