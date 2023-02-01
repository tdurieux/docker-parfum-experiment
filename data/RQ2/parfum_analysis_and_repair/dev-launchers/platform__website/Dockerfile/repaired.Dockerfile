FROM node:12
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --production && npm cache clean --force;
COPY . .
RUN npm run build
CMD ["npm", "run", "start"]