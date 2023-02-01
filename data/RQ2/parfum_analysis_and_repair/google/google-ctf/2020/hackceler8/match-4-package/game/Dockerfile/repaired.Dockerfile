FROM node:12
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 4567
CMD [ "node", "main.js" ]
