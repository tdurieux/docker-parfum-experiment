FROM node:5.2.0-slim
WORKDIR /app
COPY ./package.json /app/package.json
RUN npm install && npm cache clean --force;
COPY ./src /app/src
ENTRYPOINT ["node", "src/index.js"]