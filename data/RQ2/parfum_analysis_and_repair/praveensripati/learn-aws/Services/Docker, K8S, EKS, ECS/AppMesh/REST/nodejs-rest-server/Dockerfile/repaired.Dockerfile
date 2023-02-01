FROM node:8.6-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package.json ./
RUN npm install -quiet && npm cache clean --force;

COPY . .

EXPOSE 80
CMD ["npm", "start"]
