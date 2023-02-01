FROM node:17-alpine
WORKDIR /app
COPY . /app
RUN rm -rf ./components
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD [ "node", "app.js" ]