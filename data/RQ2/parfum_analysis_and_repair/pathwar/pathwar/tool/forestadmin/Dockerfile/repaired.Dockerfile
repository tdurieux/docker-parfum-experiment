FROM node:10-alpine
WORKDIR /usr/src/app
RUN npm install lumber-cli -g -s && npm cache clean --force;
COPY package*.json ./
RUN npm install -s && npm cache clean --force;
COPY . .
EXPOSE 3310
CMD ["npm", "start"]
