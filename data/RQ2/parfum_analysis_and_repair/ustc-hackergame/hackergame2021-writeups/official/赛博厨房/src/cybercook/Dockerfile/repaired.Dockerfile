FROM node:14

WORKDIR /app

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npx webpack --mode=production

EXPOSE 80
CMD [ "npx", "ts-node", "./src/serverAPI.ts" ]
