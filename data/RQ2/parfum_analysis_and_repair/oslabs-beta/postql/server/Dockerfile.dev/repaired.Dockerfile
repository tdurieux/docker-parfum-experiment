FROM node:13.13.0-stretch
WORKDIR /app
COPY ./package*.json ./
# set environment variable
ENV MONGOMS_SYSTEM_BINARY=/usr/local/bin/mongod
RUN npm install && npm cache clean --force;
COPY . .
CMD ["npm", "run", "dev"]