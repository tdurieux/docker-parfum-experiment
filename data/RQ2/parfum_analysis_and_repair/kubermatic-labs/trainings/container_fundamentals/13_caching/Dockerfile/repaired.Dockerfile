FROM node:12
WORKDIR /app
COPY . .
RUN npm install && npm cache clean --force;
CMD [ "npm", "start" ]