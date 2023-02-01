FROM daocloud.io/library/node:8.0.0-alpine
WORKDIR /app
COPY package.json /app
RUN npm install && npm cache clean --force;
COPY . /app
EXPOSE 8081
CMD node index.js