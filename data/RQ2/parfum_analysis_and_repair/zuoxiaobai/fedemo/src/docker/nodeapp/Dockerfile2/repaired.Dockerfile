FROM node:10-alpine
ADD . /app/
WORKDIR /app
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["node", "app.js"]
