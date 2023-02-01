FROM node:10
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
RUN npm run build
CMD [ "npm", "start" ]