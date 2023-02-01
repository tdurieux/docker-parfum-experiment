FROM node:14
WORKDIR /app
COPY package*.json ./
COPY index.js ./
RUN npm install && npm cache clean --force;
CMD ["node", "index.js"]
