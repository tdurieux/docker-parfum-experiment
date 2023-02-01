FROM node:latest

RUN mkdir -p /app
WORKDIR /app

COPY package.json /app/
RUN npm install && npm cache clean --force;

COPY . /app
EXPOSE 8080
CMD ["npm", "run", "start"]
