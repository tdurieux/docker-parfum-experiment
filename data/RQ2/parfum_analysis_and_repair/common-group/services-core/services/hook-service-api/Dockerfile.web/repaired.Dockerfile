FROM comum/hook-service:latest
WORKDIR /usr/app
COPY . .
CMD npm start server.js