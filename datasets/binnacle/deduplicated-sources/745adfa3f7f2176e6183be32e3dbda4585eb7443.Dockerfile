FROM node:6.9.2
EXPOSE 8080
COPY src/server.js .
CMD node server.js