FROM node:17

WORKDIR /app

COPY package*.json ./

RUN npm install -g eslint prettier && npm cache clean --force;

RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "run", "test:watch"]