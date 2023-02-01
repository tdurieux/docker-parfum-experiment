FROM node:12

WORKDIR /app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 6006

CMD "npm" "start"
