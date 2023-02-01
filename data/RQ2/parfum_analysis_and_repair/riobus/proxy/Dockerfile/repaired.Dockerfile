FROM node:5.7.0
EXPOSE 8080
ADD . /app
WORKDIR /app
RUN npm install && npm cache clean --force;
ENTRYPOINT npm start