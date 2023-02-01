FROM node:17-alpine
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 4000
CMD [ "node", "app.js" ]