FROM node:10-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install lumber-cli -g -s && npm cache clean --force;
RUN npm install -s && npm cache clean --force;
COPY . .
EXPOSE ${APPLICATION_PORT}
CMD ["npm", "start"]
