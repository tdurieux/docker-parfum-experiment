FROM node:14.15.4-alpine3.10
WORKDIR /usr/app
COPY package*.json ./
RUN npm install -g npm@latest && npm install --save --legacy-peer-deps && npm cache clean --force;
COPY . .
CMD ["npm", "start"]