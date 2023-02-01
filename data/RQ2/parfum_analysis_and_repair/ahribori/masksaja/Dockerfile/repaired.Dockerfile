FROM node:10-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .
RUN npm run build

EXPOSE 4444

CMD ["npm", "run", "server"]
