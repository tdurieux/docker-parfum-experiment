from node:12
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;
COPY . .
EXPOSE 3000
CMD ["node", "index.js"]