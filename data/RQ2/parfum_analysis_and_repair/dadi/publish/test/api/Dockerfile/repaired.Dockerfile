FROM node:8
WORKDIR /dadi/api
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 8081
CMD [ "npm", "start" ]
