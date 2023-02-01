FROM node:9.2-alpine

MAINTAINER Adrián García Espinosa "age.apps.dev@gmail.com"

# Create app directory
WORKDIR /app

# nodemon for development
RUN npm install -gq nodemon && npm cache clean --force;

COPY package.json ./
# Install npm and bower dependencies
RUN npm install -q && npm cache clean --force;

# Bundle app source
COPY . /app

# EXPOSE '${PORT}'
ENV PORT 3000
EXPOSE 3000

CMD [ "npm", "start" ]
