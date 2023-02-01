FROM node:6

RUN mkdir /app
WORKDIR /app

COPY package.json .

RUN npm install --production && npm cache clean --force;

COPY . .

CMD ["npm", "start"]