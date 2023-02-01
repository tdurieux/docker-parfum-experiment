FROM node:10.16
WORKDIR /usr/src/app
COPY package*.json ./
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 5555
CMD ["node", "customerserver.js"]