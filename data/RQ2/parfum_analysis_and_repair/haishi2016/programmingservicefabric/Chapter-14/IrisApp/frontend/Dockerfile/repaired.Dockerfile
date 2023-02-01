FROM node:6
WORKDIR /app
ADD ./server.js /app
RUN npm install express && npm cache clean --force;
RUN npm install request && npm cache clean --force;
EXPOSE 8081
CMD ["node", "server.js"]
