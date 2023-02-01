FROM node:alpine
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
CMD [ "npm" , "start" ]