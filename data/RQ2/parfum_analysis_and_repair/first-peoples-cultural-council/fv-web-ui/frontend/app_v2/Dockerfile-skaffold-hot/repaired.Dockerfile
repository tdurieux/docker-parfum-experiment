FROM node:lts-alpine
ENV NODE_ENV production
EXPOSE 8080
COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;
COPY . .

