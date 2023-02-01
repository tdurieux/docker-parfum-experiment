FROM node:10.18-alpine
WORKDIR /frontend
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
RUN npm install react-scripts@3.4.3 -g && npm cache clean --force;
COPY . ./