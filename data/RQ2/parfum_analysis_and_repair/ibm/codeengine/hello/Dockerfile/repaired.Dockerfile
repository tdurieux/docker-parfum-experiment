FROM icr.io/codeengine/node:12-alpine
RUN npm install && npm cache clean --force;
COPY server.js .
EXPOSE 8080
CMD [ "node", "server.js" ]
