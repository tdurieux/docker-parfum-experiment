FROM node:8-alpine
RUN npm install ws && npm cache clean --force;
EXPOSE 8080
COPY server.js /server.js
ENTRYPOINT ["node", "/server.js"]