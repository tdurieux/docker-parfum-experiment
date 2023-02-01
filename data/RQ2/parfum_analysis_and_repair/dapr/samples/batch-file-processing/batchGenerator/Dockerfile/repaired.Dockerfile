FROM node:8-alpine
WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 3003
CMD [ "node", "app.js" ]