FROM node:10.14.2
MAINTAINER Kevin Woods <kevinwoods.net>
RUN mkdir /app
# COPY . /app
WORKDIR /app
# RUN npm install webpack -g
# RUN npm install webpack-cli -g
RUN npm install npx -g && npm cache clean --force;
RUN npm install yarn -g && npm cache clean --force;
RUN npm install && npm cache clean --force;
CMD ["sh", "-c", "while true; do sleep 1; done;"]
