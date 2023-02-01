FROM node:10
WORKDIR /
COPY . .
RUN npm install && npm cache clean --force;
EXPOSE 8999 9001
CMD [ "node", "src/main.js" ]
