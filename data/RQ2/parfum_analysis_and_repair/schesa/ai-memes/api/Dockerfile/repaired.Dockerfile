FROM node:14.3.0

WORKDIR /app
COPY package.json /app
RUN npm install && npm audit fix && npm cache clean --force;
COPY . /app


CMD ["node", "./src/index.js"]

# grpc channel
EXPOSE 50051
