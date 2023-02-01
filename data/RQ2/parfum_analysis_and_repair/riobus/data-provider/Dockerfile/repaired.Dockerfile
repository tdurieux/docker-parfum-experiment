FROM node:6.2.2
ADD . /app
WORKDIR /app
RUN npm install && npm cache clean --force;
ENTRYPOINT npm start
