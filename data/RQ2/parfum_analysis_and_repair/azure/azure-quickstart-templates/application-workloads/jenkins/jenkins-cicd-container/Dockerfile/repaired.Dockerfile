FROM node:16.13.0
ENV NODE_ENV=production

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install --production && npm cache clean --force;

COPY . .

EXPOSE 80

CMD [ "node", "server.js" ]