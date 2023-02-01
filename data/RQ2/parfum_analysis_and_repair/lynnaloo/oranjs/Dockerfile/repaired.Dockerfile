FROM node:latest
ADD . .
RUN npm install && npm cache clean --force;
CMD npm start