FROM node:14
WORKDIR /usr/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build
EXPOSE 8000
CMD [ "node", "dist/index.js" ]