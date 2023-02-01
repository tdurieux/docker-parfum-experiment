FROM node:8
WORKDIR /dadi/publish
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
EXPOSE 8080
CMD [ "node", "start.js" ]
