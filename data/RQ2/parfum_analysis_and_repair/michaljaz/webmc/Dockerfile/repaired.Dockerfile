FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 8080
ENTRYPOINT ["npm", "start"]