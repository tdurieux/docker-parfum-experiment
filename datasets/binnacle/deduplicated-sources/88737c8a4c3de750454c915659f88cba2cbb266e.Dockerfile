FROM publicisworldwide/node:6.0

MAINTAINER Publicis Worldwide

USER $CONTAINER_USER

RUN npm install -g \
    gulp \
    grunt-cli \
    grunt \
    jasmine

