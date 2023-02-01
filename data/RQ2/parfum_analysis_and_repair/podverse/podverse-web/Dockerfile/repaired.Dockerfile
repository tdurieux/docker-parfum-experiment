FROM node:16
WORKDIR /tmp
COPY . .
RUN npm install && npm cache clean --force;
RUN npm run build
