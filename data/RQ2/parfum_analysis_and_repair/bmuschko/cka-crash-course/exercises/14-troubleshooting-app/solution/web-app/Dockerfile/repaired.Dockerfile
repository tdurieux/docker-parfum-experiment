FROM node:12
WORKDIR /usr/src/app
RUN npm install mysql && npm cache clean --force;
COPY . .
EXPOSE 8080
CMD ["node", "web-app.js"]