# DOCKER-VERSION 1.0.1
FROM node:0.10.31
EXPOSE 8080

# Bundle app source
COPY . /src
WORKDIR /src

RUN npm install --unsafe-perm && npm cache clean --force;
RUN npm install -g grunt && grunt && npm rm -g grunt && npm cache clean --force;
CMD node bin/cluster
