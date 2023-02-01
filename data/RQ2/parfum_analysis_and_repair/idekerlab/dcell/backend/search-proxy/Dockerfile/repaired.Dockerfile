FROM node:lts

WORKDIR /src

COPY package.json ./
RUN npm install && npm cache clean --force;

# Bundle app source (server.js)
COPY . .

# Listen port
EXPOSE 3000

CMD [ "npm", "start" ]