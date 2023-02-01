# First build an image
FROM node:8.12.0-alpine AS builder
WORKDIR /home/node/app
COPY . .
RUN npm install && npm cache clean --force;
#RUN npm run build
EXPOSE 80
CMD [ "npm", "start" ]
