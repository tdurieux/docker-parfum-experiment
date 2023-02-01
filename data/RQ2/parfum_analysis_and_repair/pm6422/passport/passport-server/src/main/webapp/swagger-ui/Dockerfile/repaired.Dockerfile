###
# swagger-ui-builder - https://github.com/swagger-api/swagger-ui/
# Container for building the swagger-ui static site
#
# Build: docker build -t swagger-ui-builder .
# Run:   docker run -v $PWD/dist:/build/dist swagger-ui-builder
#
###

FROM    ubuntu:14.04
MAINTAINER dnephin@gmail.com

ENV     DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y git npm nodejs openjdk-7-jre && rm -rf /var/lib/apt/lists/*;
RUN     ln -s /usr/bin/nodejs /usr/local/bin/nodes

WORKDIR /build
ADD     package.json    /build/package.json
RUN npm install && npm cache clean --force;
ADD     .   /build
CMD     ./node_modules/gulp/bin/gulp.js serve
