FROM node:16

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build
CMD [ "npm", "start" ]
