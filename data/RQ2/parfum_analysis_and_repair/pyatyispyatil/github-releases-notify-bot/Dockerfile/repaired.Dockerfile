FROM node:10-alpine
COPY . .
RUN npm install && npm cache clean --force;
CMD npm start
