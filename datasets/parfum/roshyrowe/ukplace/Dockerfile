FROM node:17-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY bot.js .
USER node
CMD ["node", "bot.js"]
