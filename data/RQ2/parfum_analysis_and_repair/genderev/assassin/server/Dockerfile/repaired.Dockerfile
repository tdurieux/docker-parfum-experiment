FROM node:current-slim
WORKDIR /usr/src/app
COPY package.json .
RUN npm install && npm cache clean --force;
EXPOSE 8080
CMD [ "npm", "start" ]
COPY . .
