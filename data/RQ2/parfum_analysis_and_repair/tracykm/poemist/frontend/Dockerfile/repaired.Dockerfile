FROM node:12
WORKDIR usr/src
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
CMD npm run build
