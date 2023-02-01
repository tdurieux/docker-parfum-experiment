FROM node:14.15.3-alpine
RUN npm install && npm cache clean --force;
EXPOSE 3000
