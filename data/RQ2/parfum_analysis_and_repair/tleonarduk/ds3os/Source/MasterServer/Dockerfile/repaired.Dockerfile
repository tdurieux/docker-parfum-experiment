FROM docker.io/node:17.6.0-alpine3.14
COPY . /app
WORKDIR /app
RUN npm install; npm cache clean --force;
EXPOSE 50020/tcp
ENTRYPOINT ["npm", "run", "start:dev"]
