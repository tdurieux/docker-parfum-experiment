FROM node:latest

ENV CI=true

WORKDIR /app
COPY package.json ./
RUN npm install zingchart-react --legacy-peer-deps && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY ./ ./

CMD ["npm", "run", "dev"]