FROM node:12-alpine
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm i --silent && npm cache clean --force;
COPY . .

EXPOSE 3001
CMD [ "npm", "run", "start" ]