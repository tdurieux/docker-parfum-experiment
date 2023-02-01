FROM node:12-alpine
WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD [ "node", "app.js" ]