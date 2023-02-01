FROM node:16

COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 8080
CMD [ "npm", "run", "server"]