FROM node

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --silent && npm cache clean --force;

COPY . .

CMD ["npm", "start"]