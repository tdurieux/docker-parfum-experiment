FROM node:16.15.1-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/lion
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
CMD ["node", "./dist/index.js"]
