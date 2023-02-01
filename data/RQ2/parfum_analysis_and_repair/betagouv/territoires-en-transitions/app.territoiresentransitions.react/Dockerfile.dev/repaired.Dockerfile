FROM node:14.15.1-alpine as builder
WORKDIR "/app"
COPY ./package.json ./
COPY ./package-lock.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 4200
CMD ["npm", "start"]