FROM node:14
WORKDIR /wise-old-man/docs

COPY package*.json ./

RUN npm config set ignore-scripts false
RUN rm -rf node_modules
RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build

CMD ["npm", "start"]